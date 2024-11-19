import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/constant.dart';
import 'package:meshwark_driver/app/di.dart';
import 'package:meshwark_driver/presentation/bloc/city_map_bloc/city_map_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/notification_bloc/notification_cubit.dart';
import 'package:meshwark_driver/presentation/final_trip_details/final_trip_details.dart';
import 'package:meshwark_driver/presentation/map/widgets/signalR_service.dart';
import 'package:meshwark_driver/presentation/rider_information.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/language_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';
import 'package:meshwark_driver/presentation/resources/value_manager.dart';
import 'package:vibration/vibration.dart';
import '../resources/Strings_manager.dart';
import 'widgets/map_view_widgets.dart';

class CityToCityMapView extends StatefulWidget {
  const CityToCityMapView({super.key});

  @override
  State<CityToCityMapView> createState() => _CityToCityMapViewState();
}

class _CityToCityMapViewState extends State<CityToCityMapView> {
  final SignalRService _signalRService = SignalRService();
  Map<String, dynamic>? _rideRequest;

  Map<String, dynamic> riderInformation = {};
  Map<String, dynamic> notificationData = {};
  bool isRiderHasInformation = false;
  bool hasRider = false;
  LatLng? currentLatLng;
  Location location = Location();
  StreamSubscription? subscription;
  Location liveLocation = Location();
  Set<Marker> origin = {};
  Set<Circle>? circle;
  BitmapDescriptor? myLocationIcon;
  GoogleMapController? _googleMapController;
  TextEditingController? _priceController;
  TextEditingController? _startController;
  TextEditingController? _endController;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final Completer<GoogleMapController> _controller = Completer();
  Timer? _timer;
  var currentFinalLocation = 0;
  Future<Uint8List> getMarker() async {
    ByteData byteData = await rootBundle.load("assets/icons/appLogoSplash.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List?> getBytesFromAsset(String path,
      [double? pixelRatio]) async {
    pixelRatio ??= MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 30);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  Future<void> getCurrentLocation() async {
    try {
      Uint8List? imageData =
          await getBytesFromAsset("assets/icons/appLogoSplash.png");
      var location = await liveLocation.getLocation();
      subscription?.cancel();
      subscription = liveLocation.onLocationChanged.listen((locationData) {
        LatLng newLatLan =
            LatLng(locationData.latitude!, locationData.longitude!);
        _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLan, zoom: 18.5),
        ));
      });
      updateLocation(imageData, location);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
    }
  }

  void updateLocation(Uint8List? imageData, LocationData location) {
    if (!mounted) return;
    setState(() {
      LatLng latLng = LatLng(location.latitude!, location.longitude!);
      origin.add(Marker(
        markerId: const MarkerId('me'),
        position: latLng,
        icon: BitmapDescriptor.fromBytes(imageData!),
        flat: true,
        draggable: false,
        zIndex: 2,
        anchor: const Offset(0.5, 0.5),
      ));
      circle?.add(Circle(
        circleId: const CircleId('circleId'),
        center: latLng,
        radius: location.accuracy!,
        strokeColor: ColorManager.blue,
        fillColor: ColorManager.blue.withAlpha(70),
        zIndex: 1,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<CityMapCubit>().initializeNotification();
    context.read<CityMapCubit>().fToast.init(context);
    _priceController = TextEditingController();
    _startController = TextEditingController();
    _endController = TextEditingController();
    _appPreferences.getUserId(key: 'userId').then((value) {
      Constants.id = value ?? "";
    });
    Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        currentLatLng = LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
    if (context.read<CityMapCubit>().isStart == true) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        getCurrentLocation();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
    _signalRService.rideRequestStream.listen((rideRequest) {
      setState(() {
        _rideRequest = rideRequest;
      });
      // Show the bottom sheet when a ride request is received
      _showRideRequestBottomSheet(rideRequest);
    });
    _listenForCancellationNotifications();
  }

  void _listenForCancellationNotifications() {
    _signalRService.cancellationNotificationStream.listen((data) {
      setState(() {
        notificationData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notificationData.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CancelTripDialog.showCancelTripDialog(
            context, notificationData['Reason'], () {
          Navigator.pop(context);

          setState(() {
            isRiderHasInformation = false;
            hasRider = false;
            notificationData = {};
          });
        });
      });
    }

    // isRiderHasInformation = false;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<CityMapCubit, CityMapState>(
      listener: (context, state) {
        if (state is CancelTripSuccessState) {
          isRiderHasInformation = false;
          hasRider = false;
          notificationData = {};
        }
      },
      builder: (context, state) {
        var cubit = context.read<CityMapCubit>();
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: cubit.isStart
                  ? () {
                      cubit.endTrip();
                      cubit.isStart = false;
                      cubit.endTripStatus();
                      cubit.showNotification(
                          id: 1,
                          title: AppStrings.tripInformation.tr(),
                          body: AppStrings.offlineMessage.tr());
                      cubit.showErrorMessage(
                        message: AppStrings.tripCancel.tr(),
                      );
                    }
                  : () {
                      showGeneralDialog(
                        barrierDismissible: false,
                        barrierLabel: '',
                        barrierColor: Colors.black38.withOpacity(0.8),
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (ctx, anim1, anim2) => StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Softer for a modern feel
                              ),
                              backgroundColor: ColorManager.textFormLightGrey,
                              title: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  AppStrings.tripInformation.tr(),
                                  style: getBoldStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s22.sp,
                                  ),
                                ),
                              ),
                              elevation: 6,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0.w, vertical: 16.0.h),
                              content: Container(
                                height: height * 0.35,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorManager.textFormLightGrey,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0,
                                          5), // Lighter shadows for sleekness
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          AppStrings.startPoint.tr(),
                                          style: getSemiBoldStyle(
                                            color: ColorManager.black,
                                            fontSize: FontSize.s18.sp,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        // More spacing for better clarity
                                        InkWell(
                                          onTap: () => cubit.showDialog(
                                            CupertinoPicker(
                                              magnification: 1.2,
                                              squeeze: 1.1,
                                              useMagnifier: true,
                                              itemExtent: cubit.kItemExtent,
                                              onSelectedItemChanged:
                                                  (int selectedItem) {
                                                setState(() {
                                                  cubit.currentStartCity = selectedItem;
                                                  cubit.selectedStartCity =
                                                      selectedItem;
                                                  cubit.selectedStartCityName =
                                                      selectedItem.toString();
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                cubit.startCitiesItems.length,
                                                (int index) {
                                                  return Center(
                                                    child: Text(
                                                      cubit.startCitiesItems[
                                                          index],
                                                      style: TextStyle(
                                                        color:
                                                            ColorManager.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            context,
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: height * 0.06,
                                            width: width,
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorManager.textFormDarkGrey,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Text(
                                              cubit.startCitiesItems[
                                                  cubit.selectedStartCity],
                                              style: getBoldStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          AppStrings.endPoint.tr(),
                                          style: getSemiBoldStyle(
                                            color: ColorManager.black,
                                            fontSize: FontSize.s18.sp,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        InkWell(
                                          onTap: () => cubit.showDialog(
                                            CupertinoPicker(
                                              magnification: 1.2,
                                              squeeze: 1.1,
                                              useMagnifier: true,
                                              itemExtent: cubit.kItemExtent,
                                              onSelectedItemChanged:
                                                  (int selectedItem) {
                                                setState(() {
                                                  cubit.currentEndCity = selectedItem;
                                                  cubit.selectedEndCity =
                                                      selectedItem;
                                                  currentFinalLocation = selectedItem;
                                                  cubit.selectedEndCityName =
                                                      selectedItem.toString();
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                cubit.startCitiesItems.length,
                                                (int index) {
                                                  return Center(
                                                    child: Text(
                                                      cubit.startCitiesItems[
                                                          index],
                                                      style: TextStyle(
                                                        color:
                                                            ColorManager.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            context,
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: height * 0.06,
                                            width: width,
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorManager.textFormDarkGrey,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Text(
                                              cubit.startCitiesItems[
                                                  cubit.selectedEndCity],
                                              style: getBoldStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actionsPadding:
                                  EdgeInsets.symmetric(vertical: 16.0.h),
                              actions: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: width * 0.72,
                                        height: height * 0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorManager.primary,
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (cubit.selectedStartCityName ==
                                                cubit.selectedEndCityName) {
                                              cubit.showErrorMessage(
                                                message: AppStrings
                                                    .selectDifferentCityMessage
                                                    .tr(),
                                              );
                                            } else {
                                              cubit.startTrip();
                                              cubit.startTripStatus(
                                                latitude:
                                                    currentLatLng?.latitude ??
                                                        0.0,
                                                longitude:
                                                    currentLatLng?.longitude ??
                                                        0.0,
                                                nextDestination:
                                                    cubit.startCitiesItems[
                                                        cubit.selectedEndCity],
                                              );
                                              cubit.showSuccessMessage(
                                                message: AppStrings
                                                    .startTripMessage
                                                    .tr(),
                                              );
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text(
                                            AppStrings.start.tr(),
                                            style: getSemiBoldStyle(
                                              color: ColorManager.white,
                                              fontSize: FontSize.s16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: width * 0.72,
                                        height: height * 0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorManager.error,
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppStrings.cancel.tr(),
                                            style: getSemiBoldStyle(
                                              color: ColorManager.white,
                                              fontSize: FontSize.s16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        transitionBuilder: (ctx, anim1, anim2, child) =>
                            BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 6 * anim1.value, sigmaY: 6 * anim1.value),
                          child: FadeTransition(opacity: anim1, child: child),
                        ),
                        context: context,
                      );
                    },
              child: Container(
                alignment: Alignment.center,
                height: height * 0.05,
                width: width * 0.6,
                decoration: BoxDecoration(
                    color: cubit.isStart
                        ? ColorManager.error
                        : ColorManager.primary,
                    borderRadius: BorderRadius.circular(
                        AppSize.s16), // Increased border radius
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ]),
                // Added shadow for depth
                child: Text(
                  cubit.isStart ? AppStrings.end.tr() : AppStrings.start.tr(),
                  style: getSemiBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s18.sp),
                ),
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ColorManager.transparent,
                statusBarIconBrightness: Brightness.dark),
            backgroundColor: Colors.white.withOpacity(0.9),
            // Slightly transparent for modern feel
            elevation: 0,
            // Removed elevation for a flat, modern app bar
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                      tag: AppStrings.cityToCity,
                      child: Image.asset(
                        ImageAssets.carSelect,
                        height: width * 0.2,
                        width: width * 0.2,
                        color: ColorManager.primary,
                      )),
                ),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              GoogleMap(
                buildingsEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(currentLatLng?.latitude ?? 0.0,
                        currentLatLng?.longitude ?? 0.0),
                    zoom: 8,
                    bearing: 11),
                markers: origin,
                circles: Set.of((circle != null ? circle! : [])),
                onMapCreated: (GoogleMapController googleMapController) {
                  _googleMapController = googleMapController;
                  _controller.complete(googleMapController);
                },
              ),
              isRiderHasInformation == false
                  ? Container()
                  : Positioned(
                      top: 80.h,
                      right: 0,
                      left: 0,
                      child: RiderInformation(
                        riderId:
                            "${riderInformation['riderId'] ?? riderInformation['request']?['riderId']}",
                        firstName:
                            "${riderInformation['firstName'] ?? riderInformation['request']?['firstName']}",
                        lastName:
                            "${riderInformation['lastName'] ?? riderInformation['request']?['lastName']}",
                        phoneNumber:
                            "${riderInformation['phoneNumber'] ?? riderInformation['request']?['phoneNumber']}",
                        dismiss: () {
                          setState(() {
                            isRiderHasInformation = false;
                          });
                        },
                        riderEnterConfirm: (){
                          Timer(const Duration(seconds: 2), () {
                            setState(() {
                              isRiderHasInformation = false;
                            });
                          });
                        },
                      ),
                    ),
              hasRider == false
                  ? Container()
                  : Positioned(
                      bottom: 15,
                      left: 150,
                      child: ToFinalDestination(
                        takeMeToFinalLocation: () async {
                          print(currentFinalLocation.toString());
                          final url =
                              'https://www.google.com/maps/dir/?api=1&destination=${cubit.citiesLocation[currentFinalLocation][0]},${cubit.citiesLocation[currentFinalLocation][1]}';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            // Handle the error, e.g., show a snackbar or dialog
                          }
                          if(context.mounted){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const TripDetailsView()));
                          }

                        },
                      ))
            ],
          ),
          floatingActionButton: CustomFloatingActionButton(
            takeMeToMyLocation: getCurrentLocation,
          ),
        );
      },
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _startController?.dispose();
    _endController?.dispose();
    _priceController?.dispose();
    subscription?.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  Widget _buildRiderList(int count, Color color, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
          child: Container(
            alignment: Alignment.center,
            height: height * 0.02,
            width: width * 0.1,
            child: Center(
              child: Icon(
                Icons.person,
                color: color,
                size: AppSize.s30,
              ),
            ),
          ),
        );
      },
    );
  }
  void _showRideRequestBottomSheet(Map<String, dynamic> rideRequest) async {
    // Initialize the audio player
    final audioPlayer = AudioPlayer();
    // Play the notification sound (make sure you have a sound file in your assets)
    await audioPlayer.play(AssetSource('sounds/requestAlert.wav'));
    riderInformation = rideRequest;
    // Check for vibration support and trigger vibration
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500); // Vibrate for 500 milliseconds
    }
    if (mounted) {
      context.read<NotificationCubit>().addNotification(
          bodyOfNotification:
              "${rideRequest['firstName'] ?? rideRequest['request']?['firstName']} ${rideRequest['lastName'] ?? rideRequest['request']?['lastName']}");
    }
    
    // Safely access nested map values
    double? riderLatitude =
        rideRequest['latitude'] ?? rideRequest['request']?['latitude'];
    double? riderLongitude =
        rideRequest['longitude'] ?? rideRequest['request']?['longitude'];

    LatLng driverLocation =
        LatLng(currentLatLng?.latitude ?? 0.0, currentLatLng?.longitude ?? 0.0);
    LatLng riderLocation = LatLng(riderLatitude ?? 0.0, riderLongitude ?? 0.0);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(driverLocation.latitude, riderLocation.latitude),
        min(driverLocation.longitude, riderLocation.longitude),
      ),
      northeast: LatLng(
        max(driverLocation.latitude, riderLocation.latitude),
        max(driverLocation.longitude, riderLocation.longitude),
      ),
    );

    LatLng calculateCenter(LatLngBounds bounds) {
      final double centerLat =
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
      final double centerLng =
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
      return LatLng(centerLat, centerLng);
    }

    double calculateDistance(LatLng from, LatLng to) {
      const double earthRadius = 6371; // Earth's radius in kilometers
      final double lat1 = from.latitude * pi / 180;
      final double lat2 = to.latitude * pi / 180;
      final double lon1 = from.longitude * pi / 180;
      final double lon2 = to.longitude * pi / 180;

      final double a = sin((lat2 - lat1) / 2) * sin((lat2 - lat1) / 2) +
          cos(lat1) *
              cos(lat2) *
              sin((lon2 - lon1) / 2) *
              sin((lon2 - lon1) / 2);
      final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      return earthRadius * c;
    }

    double calculateDuration(double distance) {
      // Assuming an average speed of 50 km/h
      const double speed = 50.0; // km/h
      final double durationInHours = distance / speed;
      final int durationInMinutes = (durationInHours * 60).toInt();
      return durationInMinutes.toDouble();
    }

    double distance = calculateDistance(driverLocation, riderLocation);
    double duration = calculateDuration(distance);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(25)), // More modern and rounded top corners
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.1), // Subtle shadow for elevation
                blurRadius: 15,
                offset: const Offset(0, -4), // Shadow direction
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors
                          .grey[300], // Handle for better grip visualization
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    AppStrings.newRideRequest.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Map Container with shadow and rounded edges
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(
                      markers: {
                        Marker(
                          markerId: MarkerId(AppStrings.rider.tr()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          position: riderLocation,
                        ),
                        Marker(
                          markerId: MarkerId(AppStrings.me.tr()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          position: driverLocation,
                        ),
                      },
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: calculateCenter(bounds),
                        zoom: 12,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        controller.animateCamera(
                          CameraUpdate.newLatLngBounds(bounds, 50),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow(Icons.person,
                    '${rideRequest['firstName'] ?? rideRequest['request']?['firstName']} ${rideRequest['lastName'] ?? rideRequest['request']?['lastName']}'),
                _buildInfoRow(Icons.attach_money,
                    '${rideRequest['price'] ?? rideRequest['request']?['price']} ${AppStrings.riyal.tr()}'),
                _buildInfoRow(Icons.people,
                    '${rideRequest['passengers'] ?? rideRequest['request']?['passengers']} ${AppStrings.passengers.tr()}'),
                _buildInfoRow(Icons.place,
                    '${distance.toStringAsFixed(2)} ${AppStrings.km.tr()}'),
                _buildInfoRow(Icons.timer,
                    '${duration.toStringAsFixed(0)} ${AppStrings.minutes.tr()}'),
                const SizedBox(height: 24),
                // Buttons with modern styles
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // print("RRRRRRRRRRR : $riderInformation");
                          setState(() {
                            isRiderHasInformation = true;
                            hasRider = true;
                          });
                          final cubit = context.read<CityMapCubit>();
                          try {
                            // await cubit.signalRService.hubConnection.invoke(
                            //   'SendDriverResponse',
                            //   args: [
                            //     rideRequest['riderId'] ??
                            //         rideRequest['request']?['riderId'],
                            //     true,
                            //   ],
                            // );
                            cubit.addPassenger(
                              "${rideRequest['request']?['firstName']} ${rideRequest['request']?['lastName']}",
                              rideRequest['request']?['passengers'],
                              rideRequest['request']?['price'],
                            );
                            cubit.sendDriverResponse(
                                riderId:
                                    "${rideRequest['riderId'] ?? rideRequest['request']?['riderId']}",
                                isAccepted: true);
                          } catch (e) {
                            // Handle error, e.g., show a snackbar with error message
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("failed")));
                            }
                          }

                          if (context.mounted) Navigator.pop(context);
                          final url =
                              'https://www.google.com/maps/dir/?api=1&destination=$riderLatitude,$riderLongitude';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            // Handle the error, e.g., show a snackbar or dialog
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          // Flat button for modern look
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          AppStrings.accept.tr(),
                          style: getSemiBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16.sp,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final cubit = context.read<CityMapCubit>();
                          // await cubit.signalRService.hubConnection
                          //     .invoke('SendDriverResponse', args: [
                          //   rideRequest['riderId'] ??
                          //       rideRequest['request']?['riderId'],
                          //   false
                          // ]);

                          cubit.sendDriverResponse(
                              riderId:
                                  "${rideRequest['riderId'] ?? rideRequest['request']?['riderId']}",
                              isAccepted: false);

                          if (context.mounted) Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.notifications_active,
                                      color: Colors.white),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppStrings.notifications.tr(),
                                          style: getSemiBoldStyle(
                                              color: ColorManager.white,
                                              fontSize: FontSize.s16.sp),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          AppStrings.rejectedMessageSentToRider
                                              .tr(),
                                          style: getSemiBoldStyle(
                                              color: ColorManager.white,
                                              fontSize: FontSize.s16.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: ColorManager.error,
                              duration: const Duration(seconds: 4),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              action: SnackBarAction(
                                label: AppStrings.close.tr(),
                                textColor: Colors.white,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );



                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          AppStrings.reject.tr(),
                          style: getSemiBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Modern icon with subtle shadow and gradient effect
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ColorManager.primary, ColorManager.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset:
                      const Offset(2, 4), // Offset for a subtle shadow effect
                ),
              ],
            ),
            padding:
                const EdgeInsets.all(10), // Adjust the padding to give it space
            child: Icon(
              icon,
              size: 24,
              color: Colors
                  .white, // White icon for better contrast with the background
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18, // Slightly larger font for modern appeal
                color: Colors.grey[900], // Darker color for better legibility
                fontWeight:
                    FontWeight.w600, // Semi-bold weight for a stronger presence
                letterSpacing:
                    0.2, // Slightly spaced-out letters for a clean look
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
