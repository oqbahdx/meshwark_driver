import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwark_driver/presentation/map/widgets/signalR_service.dart';
import '../../../app/constant.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/user_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'city_map_state.dart';

class CityMapCubit extends Cubit<CityMapState> {
  CityMapCubit() : super(CityMapInitial());
  SignalRService signalRService = SignalRService();
  late StreamSubscription _driverUpdateSubscription;
  late StreamSubscription _driverResponseSubscription;
  bool isStart = false;
  List<Map<String, dynamic>> passengers = [];
  int currentStartCity = 0;
  int currentEndCity = 0;
  void _initializeSignalR() {
    signalRService.initializeConnection();
    _listenToDriverUpdates();
    _listenToDriverResponses();
  }
  void addPassenger(String name, int passengersCount, int amount) {
      passengers.add({
        "name": name,
        "passengers": passengersCount,
        "amount": amount,
      });
    emit(AddPassengerState());
  }

  Future<void> notifyRider({required String? riderId}) async {
    DioHelper.postData(endPoint: Constants.notifyRiderEndPoint, data: {
      "riderId": riderId,
      "driverId": Constants.id,
      "message": "this is a message"
    });
  }

  Future<void> cancelTrip({
    required String? riderId,
    required String? reason,
  }) async {
    emit(CancelTripLoadingState());
    DioHelper.postData(endPoint: Constants.cancelTripEndPoint, data: {
      "riderId": riderId,
      "driverId": Constants.id,
      "reason": reason,
      "cancellingParty": "Driver"
    }).then((value) {
      emit(CancelTripSuccessState());
      debugPrint(value.toString());
    }).catchError((error) {
      emit(CancelTripErrorState(error.toString()));
      debugPrint(error.toString());
    });
  }

  void initializeSignalRAndListenForRideRequests() {
    signalRService.initializeConnection();
    signalRService.rideRequestStream.listen((rideRequest) {
      emit(RideRequestReceivedState(
          rideRequest['riderId'], rideRequest['request']));
    });
  }

  void _listenToDriverUpdates() {
    _driverUpdateSubscription =
        signalRService.driverUpdateStream.listen((update) {
      userModel = UserModel.fromJson(update);
      emit(DriverUpdateReceivedState(userModel!));
    });
  }

  void _listenToDriverResponses() {
    _driverResponseSubscription =
        signalRService.driverResponseStream.listen((response) {
      emit(DriverResponseReceivedState(response));
    });
  }

  @override
  Future<void> close() {
    _driverUpdateSubscription.cancel();
    _driverResponseSubscription.cancel();
    signalRService.dispose();
    return super.close();
  }

  void startTrip() {
    isStart = true;
    emit(CancelTripState());
  }

  void endTrip() {
    isStart = false;
    emit(StartTripState());
  }

  // void endCityToCityTrip() async {
  //   List<ConnectivityResult> connectivityResult =
  //       await (Connectivity().checkConnectivity());
  //   if (connectivityResult.contains(ConnectivityResult.mobile) ||
  //       connectivityResult.contains(ConnectivityResult.wifi)) {
  //     emit(EndCityToCityTripLoadingState());
  //     DioHelper.updateData(
  //         endPoint: "${Constants.updateTripStatusEndPoint}/${Constants.id}",
  //         data: {
  //           "id": Constants.id,
  //           "isOnline": false,
  //           "availableSeats": Constants.carSeats,
  //           "reservedSeats": 0
  //         }).then((value) {
  //       if (kDebugMode) {
  //         print(value.toString());
  //         emit(EndCityToCityTripSuccessState());
  //       }
  //     }).catchError((error) {
  //       if (kDebugMode) {
  //         print(error.toString());
  //         emit(EndCityToCityTripErrorState(error.toString()));
  //       }
  //     });
  //   }
  // }

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id", "channel_name",
            channelDescription: "channelDescription",
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  showErrorMessage({required String message}) {
    Widget toast = Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8),
        color: ColorManager.error,
      ),
      child: Text(
        message,
        style:
            getBoldStyle(color: ColorManager.white, fontSize: FontSize.s16.sp),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: const Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         top: 16.0,
    //         left: 16.0,
    //         child: child,
    //       );
    //     });
  }

  showSuccessMessage({required String message}) {
    Widget toast = Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8),
        color: ColorManager.teal,
      ),
      child: Text(
        message,
        style: getBoldStyle(color: ColorManager.white, fontSize: FontSize.s16),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: const Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         top: 16.0,
    //         left: 16.0,
    //         child: child,
    //       );
    //     });
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final notificationDetails = _notificationDetails();
    await _localNotificationService.show(id, title, body, notificationDetails);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (kDebugMode) {
      print("id : $id");
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    if (kDebugMode) {
      print("$details");
    }
  }

  void showDialog(Widget child, BuildContext ctx) {
    showCupertinoModalPopup<void>(
      context: ctx,
      builder: (BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 250,
        // Adjusted height for more content space
        padding: const EdgeInsets.all(16.0),
        // Added padding for better layout
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10, // Subtle shadow for depth
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  double kItemExtent = 32.0;
  int selectedStartCity = 0;
  int selectedEndCity = 0;

  changeStartCityItems(int item) {
    selectedStartCity = item;
    emit(ChangeStartCityState());
  }

  changeEndCityItems(int item) {
    selectedEndCity = item;
    emit(ChangeEndCityState());
  }
  var citiesLocation = [
   [24.7136, 46.6753], // Riyadh
   [21.4858, 39.1925], // Jeddah
   [26.3927, 49.9777], // Dammam
   [24.5247, 39.5692], // Medina
   [21.2854, 40.4260], // Taif
   [28.3838, 36.5600], // Tabuk
   [27.5114, 41.7208], // Hail
   [26.2754, 50.2116], // Al Khobar
   [21.3891, 39.8579], // Mecca
   [17.5654, 44.2289], // Najran
   [16.8890, 42.5510], // Jazan
   [27.0046, 49.6469], // Al Jubail
   [26.5652, 49.9981], // Al Qatif
   [24.0896, 38.0614], // Yanbu
   [26.3351, 43.9750], // Buraydah
   [25.3643, 49.5946], // Al Hofuf
   [18.2161, 42.5051], // Abha
   [18.3094, 42.7291], // Khamis Mushait
   [30.1236, 40.4170], // Sakaka
   [20.0129, 41.4677], // Al Bahah
   [28.4342, 45.9636], // Hafer Al Batin
   [31.3302, 37.3443], // Al Qurayyat
   [24.5117, 44.4002], // Al Duwadimi
   [26.2886, 50.1136], // Dhahran
  ];
  var startCitiesItems = [
    AppStrings.riyadh.tr(),
    AppStrings.jeddah.tr(),
    AppStrings.dammam.tr(),
    AppStrings.medina.tr(),
    AppStrings.taif.tr(),
    AppStrings.tabuk.tr(),
    AppStrings.hail.tr(),
    AppStrings.alKhobar.tr(),
    AppStrings.mecca.tr(),
    AppStrings.najran.tr(),
    AppStrings.jazan.tr(),
    AppStrings.alJubail.tr(),
    AppStrings.alQatif.tr(),
    AppStrings.yanbu.tr(),
    AppStrings.buraydah.tr(),
    AppStrings.alHofuf.tr(),
    AppStrings.abha.tr(),
    AppStrings.khamisMushait.tr(),
    AppStrings.sakaka.tr(),
    AppStrings.alBahah.tr(),
    AppStrings.haferAlBatin.tr(),
    AppStrings.alQurayyat.tr(),
    AppStrings.alDuwadimi.tr(),
    AppStrings.dhahran.tr(),
  ];
  String selectedStartCityName = "";
  String selectedEndCityName = "";
  var endCitiesItems = [
    AppStrings.riyadh.tr(),
    AppStrings.jeddah.tr(),
    AppStrings.dammam.tr(),
    AppStrings.medina.tr(),
    AppStrings.taif.tr(),
    AppStrings.tabuk.tr(),
    AppStrings.hail.tr(),
    AppStrings.alKhobar.tr(),
    AppStrings.mecca.tr(),
    AppStrings.najran.tr(),
    AppStrings.jazan.tr(),
    AppStrings.alJubail.tr(),
    AppStrings.alQatif.tr(),
    AppStrings.yanbu.tr(),
    AppStrings.buraydah.tr(),
    AppStrings.alHofuf.tr(),
    AppStrings.abha.tr(),
    AppStrings.khamisMushait.tr(),
    AppStrings.sakaka.tr(),
    AppStrings.alBahah.tr(),
    AppStrings.haferAlBatin.tr(),
    AppStrings.alQurayyat.tr(),
    AppStrings.alDuwadimi.tr(),
    AppStrings.dhahran.tr(),
  ];

  String getCityToString(int city) {
    switch (city) {
      case 0:
        return AppStrings.riyadh.tr();
      case 1:
        return AppStrings.jeddah.tr();
      case 2:
        return AppStrings.dammam.tr();
      case 3:
        return AppStrings.medina.tr();
      case 4:
        return AppStrings.taif.tr();
      case 5:
        return AppStrings.tabuk.tr();
      case 6:
        return AppStrings.hail.tr();
      case 7:
        return AppStrings.alKhobar.tr();
      case 8:
        return AppStrings.mecca.tr();
      case 9:
        return AppStrings.najran.tr();
      case 10:
        return AppStrings.alJubail.tr();
      case 11:
        return AppStrings.jazan.tr();
      case 12:
        return AppStrings.alQatif.tr();
      case 13:
        return AppStrings.yanbu.tr();
      case 14:
        return AppStrings.buraydah.tr();
      case 15:
        return AppStrings.alHofuf.tr();
      case 16:
        return AppStrings.abha.tr();
      case 17:
        return AppStrings.khamisMushait.tr();
      case 18:
        return AppStrings.sakaka.tr();
      case 19:
        return AppStrings.alBahah.tr();
      case 20:
        return AppStrings.haferAlBatin.tr();
      case 21:
        return AppStrings.alQurayyat.tr();
      case 22:
        return AppStrings.alDuwadimi.tr();
      case 23:
        return AppStrings.dhahran.tr();
      default:
        return "";
    }
  }

  startTripStatus({
    required double latitude,
    required double longitude,
    required String nextDestination,
  }) {
    DioHelper.updateData(
        endPoint: "${Constants.updateTripStatusEndPoint}/${Constants.id}",
        data: {
          "id": Constants.id,
          "isOnline": true,
          "latitude": latitude,
          "longitude": longitude,
          "nextDestination": nextDestination,
          "availableSeats": 4,
          "reservedSeats": 0,
        });
    // signalRService.initializeConnection();
  }

  endTripStatus() {
    DioHelper.updateData(
        endPoint: "${Constants.updateTripStatusEndPoint}/${Constants.id}",
        data: {"id": Constants.id, "isOnline": false, "reservedSeats": 0});
    signalRService.dispose();
  }

  UserModel? userModel;

  // void startCityToCityTrip(
  //     {required String nextDestination,
  //     required double latitude,
  //     required double longitude}) async {
  //   List<ConnectivityResult> connectivityResult =
  //       await Connectivity().checkConnectivity();
  //   if (connectivityResult.contains(ConnectivityResult.mobile) ||
  //       connectivityResult.contains(ConnectivityResult.wifi)) {
  //     emit(StartCityToCityTripLoadingState());
  //     DioHelper.updateData(
  //         endPoint: "${Constants.updateTripStatusEndPoint}/${Constants.id}",
  //         data: {
  //           "id": Constants.id,
  //           "isOnline": true,
  //           "latitude": latitude,
  //           "longitude": longitude,
  //           "nextDestination": nextDestination,
  //           "availableSeats": 4,
  //           "reservedSeats": 0
  //         }).then((value) {
  //       initializeSignalRAndListenForRideRequests();
  //       if (kDebugMode) {
  //         userModel = UserModel.fromJson(value!.data);
  //         print(value.toString());
  //       }
  //       emit(StartCityToCityTripSuccessState());
  //     }).catchError((error) {
  //       if (kDebugMode) {
  //         print(error.toString());
  //       }
  //       emit(StartCityToCityTripErrorState(error.toString()));
  //     });
  //   }
  // }

  var randomNumber = Random().nextInt(9999999);

  addTripHistory({required String startPoint, required String endPoint}) async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(AddTripHistoryLoadingState());
      // todo : add trip history new endpoint
      DioHelper.postData(
          endPoint: '${Constants.tripsEndPoint}/${Constants.id}',
          data: {
            'trip_number': randomNumber,
            'day': DateTime.now().day,
            'month': DateTime.now().month,
            'time': DateTime.now().toString(),
            'start_point': startPoint,
            'end_point': endPoint,
          }).then((value) {
        if (kDebugMode) {
          print(value.toString());
          emit(AddTripHistorySuccessState());
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
          emit(AddTripHistoryErrorState(error.toString()));
        }
      });
    } else {
      showNoInternetMessage();
    }
  }

  Future<void> sendDriverResponse(
      {required String? riderId, required bool isAccepted}) async {
    DioHelper.postData(
        endPoint: Constants.sendDriverResponseEndPoint,
        data: {"riderId": riderId, "accepted": isAccepted}).then((value) {
      print(value.toString());
    }).catchError((err) {
      print(err.toString());
    });
  }

  FToast fToast = FToast();

  showNoInternetMessage() {
    Widget toast = Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8),
        color: ColorManager.textFormDarkGrey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            AppStrings.noInternetConnection.tr(),
            style:
                getBoldStyle(color: ColorManager.black, fontSize: FontSize.s16),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
