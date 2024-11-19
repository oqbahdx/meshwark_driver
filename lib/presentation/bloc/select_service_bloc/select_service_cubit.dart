import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/di.dart';

import '../../../app/constant.dart';
import '../../../data/network/dio_helper.dart';

import '../../../domain/user_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'select_service_state.dart';

class SelectServiceCubit extends Cubit<SelectServiceState> {
  SelectServiceCubit() : super(SelectServiceInitial());
  final AppPreferences _appPreferences = instance<AppPreferences>();
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
  showWarringMessage({required String message}) {
    Widget toast = Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8),
        color: ColorManager.textFormLightGrey,
      ),
      child: Text(
        message,
        style: getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s16),
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
  UserModel? userModel;

  void getUser() async {
    emit(GetCurrentDriverLoadingState());

    // Check the connectivity status
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {

      // Get the user ID from preferences
      _appPreferences.getUserId(key: 'userId').then((value) {
        Constants.id = value!;

        // Initialize Dio and make the API call
        DioHelper.init();
        DioHelper.getData(
            endPoint: '${Constants.getUserEndPoint}/${Constants.id}'
        ).then((value) {
          emit(GetCurrentDriverSuccessState());

          // Parse the response to userModel
          userModel = UserModel.fromJson(value?.data);

          // Set user data in preferences
          _appPreferences.setCarSeats(key: "carSeats", value: userModel?.availableSeats ?? 0);
          _appPreferences.setFirstName(key: 'firstName', value: userModel?.firstName ?? "");
          _appPreferences.setLastName(key: 'lastName', value: userModel?.lastName ?? "");
          _appPreferences.setUserId(key: 'userId', value: userModel?.id ?? "");

          // Debug information
          if (kDebugMode) {
            print("userId from get user : ${Constants.id}");
            print("available seats : ${userModel?.availableSeats}");
            print("first name : ${userModel?.firstName}");
            print("last name : ${userModel?.lastName}");
            print("success");
          }

        }).catchError((error) {
          if (kDebugMode) {
            print(error.toString());
            print("failure");
          }
          emit(GetCurrentDriverErrorState(error.toString()));
        });
      });

    } else {
      // Show no internet message
      showNoInternetMessage();
    }
  }


  bool isCar = false;
  bool isTruck = false;
  bool isVan = false;
  bool isComplete = false;
  String service = "";

  setCarTrue() {
    isCar = true;
    isTruck = false;
    isVan = false;
    isComplete = true;
    // service = "car_marker";
    emit(SetCarTrueState());
  }

  setVanTrue() {
    isCar = false;
    isTruck = false;
    isVan = true;
    isComplete = true;
    // service = "move_car";
    emit(SetVanTrueState());
  }

  setTruckTrue() {
    isCar = false;
    isTruck = true;
    isVan = false;
    isComplete = true;
    emit(SetTruckTrueState());
  }
// Assuming all necessary imports are done and variables like `AppSize`, `ColorManager`, etc., are defined elsewhere.
}
