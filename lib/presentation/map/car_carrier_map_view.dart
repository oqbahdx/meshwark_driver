import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;

import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';

import '../bloc/carrier_map_bloc/carrier_map_cubit.dart';
import '../resources/value_manager.dart';
import 'widgets/map_view_widgets.dart';

class CarCarrierMapView extends StatefulWidget {
  const CarCarrierMapView({super.key});

  @override
  State<CarCarrierMapView> createState() => _CarCarrierMapViewState();
}

class _CarCarrierMapViewState extends State<CarCarrierMapView> {
  StreamSubscription? subscription;
  Location liveLocation = Location();
  GoogleMapController? _googleMapController;
  Set<Marker>? origin = {};
  Set<Circle>? circle;
  LatLng? currentLatLng;
  final Completer<GoogleMapController> _controller = Completer();

  Future<Uint8List> getMarker() async {
    ByteData byteData = await rootBundle.load(ImageAssets.moveCar);
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List?> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 40);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  getCurrentLocation() async {
    try {
      Uint8List? imageData = await getBytesFromAsset(ImageAssets.moveCar);
      var location = await liveLocation.getLocation();
      if (subscription != null) {
        subscription?.cancel();
      }
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

  updateLocation(Uint8List? imageData, LocationData location) {
    LatLng latLng = LatLng(location.latitude!, location.longitude!);
    setState(() {
      origin?.add(Marker(
        markerId: const MarkerId(
          'me',
        ),
        position: latLng,
        icon: BitmapDescriptor.fromBytes(imageData!),
        flat: true,
        draggable: false,
        zIndex: 2,
        anchor: const Offset(0.5, 0.5),
        rotation: location.heading!,
      ));
    });
    circle?.add(Circle(
      circleId: const CircleId('circleId'),
      center: latLng,
      radius: location.accuracy!,
      strokeColor: ColorManager.blue,
      fillColor: ColorManager.blue.withAlpha(70),
      zIndex: 1,
    ));
  }
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        currentLatLng = LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          getCurrentLocation();
        }));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocConsumer<CarrierMapCubit, CarrierMapState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = context.read<CarrierMapCubit>();
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                      tag: AppStrings.van,
                      child: Image.asset(
                        ImageAssets.truckSelect,
                        height: width * 0.2,
                        width: width * 0.2,
                        color: ColorManager.primary,
                      )),
                ),
              )
            ],
            title: cubit.isMoveFurnitureActive
                ? BuildElevatedButton(
              text: AppStrings.end.tr(),
              color: ColorManager.error,
              onTap: () {
                cubit.endMoveFurniture();
                Fluttertoast.showToast(
                    msg: AppStrings.offlineMessage.tr(),
                    backgroundColor: ColorManager.error);
              },
            )
                : BuildElevatedButton(
              text: AppStrings.start.tr(),
              color: ColorManager.primary,
              onTap: () {
                cubit.startMoveFurniture();
                Fluttertoast.showToast(
                    msg: AppStrings.onlineMessage.tr(),
                    backgroundColor: ColorManager.teal);
              },
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: ColorManager.transparent,
            ),
            elevation: 0.0,
            backgroundColor: ColorManager.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: currentLatLng == null
              ? Center(
              child: lottie.Lottie.asset(JsonAssets.mapLoading,
                  height: width * 0.5, width: width * 0.5))
              : GoogleMap(
            buildingsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(currentLatLng?.latitude ?? 0.0,
                    currentLatLng?.longitude ?? 0.0),
                zoom: 8,
                bearing: 11),
            mapToolbarEnabled: false,
            markers: Set.of((origin != null ? origin! : [])),
            circles: Set.of((circle != null ? circle! : [])),
            onMapCreated: (GoogleMapController controller) async {
              _googleMapController = controller;
              _controller.complete(controller);
              // setState(() {
              //   getCurrentLocation();
              // });
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorManager.primary,
            onPressed: () {
              getCurrentLocation();
            },
            child: Icon(
              Icons.location_history,
              color: ColorManager.white,
              size: AppSize.s40,
            ),
          ),
          floatingActionButtonLocation: cubit.isStart
              ? FloatingActionButtonLocation.centerFloat
              : FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
  @override
  void dispose() {
    _timer?.cancel();
    subscription?.cancel();
    super.dispose();
  }
}
