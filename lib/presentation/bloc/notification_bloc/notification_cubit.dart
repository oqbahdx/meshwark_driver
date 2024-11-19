import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app/constant.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/notification_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
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

  final today = DateTime.now();

  Future<void> addNotification({required String bodyOfNotification}) async {
    // Format the date and time as ISO 8601 string
    String formattedDate = DateFormat("yyyy-MM-dd").format(today);
    String formattedTime = DateFormat("HH:mm").format(today);

    await DioHelper.postData(
        endPoint: "${Constants.addNotificationsEndPoint}/${Constants.id}",
        data: {
          "id": Constants.id,
          "userId": Constants.id,
          "title": AppStrings.incomingOrder.tr(),
          "body":
              "${AppStrings.newRideRequest.tr()}${AppStrings.from.tr()} : $bodyOfNotification",
          "date": formattedDate, // Sending ISO 8601 formatted date
          "time": formattedTime, // Sending ISO formatted time
        });
  }

  List<NotificationModel>? notificationList;

  Future<void> getNotification() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(NotificationLoadingState());
      DioHelper.getData(
              endPoint: '${Constants.notificationsEndPoint}/${Constants.id}')
          .then((value) {
        notificationList = (value?.data as List)
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();
        if (kDebugMode) {
          for (var notification in notificationList!) {
            print(notification.body);
          }
        }
        emit(NotificationSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(NotificationErrorState(error.toString()));
      });
    } else {
      showNoInternetMessage();
    }
  }

  Future<void> getNotificationAfterDeleteItem() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(NotificationLoadingState());
      DioHelper.getData(
              endPoint: '${Constants.notificationsEndPoint}/${Constants.id}')
          .then((value) {
        notificationList = (value?.data as List)
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();
        if (kDebugMode) {
          for (var notification in notificationList!) {
            print(notification.body);
          }
        }
        emit(NotificationSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(NotificationErrorState(error.toString()));
      });
    } else {
      showNoInternetMessage();
    }
  }

  void deleteNotification({required dynamic id}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(DeleteNotificationLoadingState());
      DioHelper.delete(
              endPoint: '${Constants.notificationsEndPoint}/${Constants.id}')
          .then((value) {
        if (kDebugMode) {
          print(value.toString());
          emit(DeleteNotificationSuccessState());
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
          emit(DeleteNotificationErrorState(error.toString()));
        }
      });
    }
  }
}
