import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app/constant.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/trip_history_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'trip_history_state.dart';

class TripHistoryCubit extends Cubit<TripHistoryState> {
  TripHistoryCubit() : super(TripHistoryInitial());
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
            style: getBoldStyle(
                color: ColorManager.black, fontSize: FontSize.s16.sp),
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

  List<TripModel>? tripList;

  void getTripHistory() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(TripHistoryLoadingState());
      DioHelper.getData(endPoint: '${Constants.tripsEndPoint}/${Constants.id}')
          .then((value) {
        tripList = (value?.data as List)
            .map((trip) => TripModel.fromJson(trip))
            .toList();
        emit(TripHistorySuccessState());
        if (kDebugMode) {
          print(value.toString());
          for (var trip in tripList!) {
            print(trip.startPoint);
          }
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(TripHistoryErrorState(error));
      });
    } else {
      showNoInternetMessage();
    }
  }

  var randomNumber = Random().nextInt(9999999);

  addTripHistory({required String startPoint, required String endPoint}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(AddTripHistoryLoadingState());
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
}
