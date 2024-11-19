import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../app/constant.dart';
import '../../../data/network/dio_helper.dart';

part 'move_map_state.dart';

class MoveMapCubit extends Cubit<MoveMapState> {
  MoveMapCubit() : super(MoveMapInitial());
  bool isMoveFurnitureActive = false;
  bool isStart = false;
  startMoveFurniture() {
    isMoveFurnitureActive = true;
    emit(StartMoveFurnitureState());
  }

  endMoveFurniture() {
    isMoveFurnitureActive = false;
    emit(EndMoveFurnitureState());
  }  void endMoveFurnitureTrip() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(EndCityToCityTripLoadingState());
      DioHelper.postData(
          endPoint: "/update-driver-profile?driver_id=${Constants.id}",
          data: {
            "isOnline": 0,
          }).then((value) {
        if (kDebugMode) {
          print(value.toString());
          emit(EndCityToCityTripSuccessState());
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
          emit(EndCityToCityTripErrorState(error.toString()));
        }
      });
    }
  }
  void startMoveFurnitureTrip() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(StartCityToCityTripLoadingState());
      DioHelper.postData(
          endPoint: "/update-driver-profile?driver_id=${Constants.id}",
          data: {
            "isOnline": 1,
            "service": "move furniture",
          }).then((value) {
        if (kDebugMode) {
          print(value.toString());
        }
        emit(StartCityToCityTripSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(StartCityToCityTripErrorState(error.toString()));
      });
    }
  }
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
}
