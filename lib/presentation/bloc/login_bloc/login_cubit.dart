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
import '../../../domain/login_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool isPassword = true;
  FToast fToast = FToast();
  void makePasswordVisible() {
    isPassword = !isPassword;
    emit(MakePasswordVisibleState());
  }

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

  showErrorMessage({required String message}) {
    Widget toast = Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8),
        color: const Color(0xFFE72831),
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

  LoginModel? loginModel;

  void login({required String number, required String password}) async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(LoginLoadingState());
      DioHelper.postData(endPoint: Constants.loginEndPoint, data: {
        "phoneNumber": number,
        "password": password,
      }).then((value) {
        loginModel = LoginModel.fromJson(value?.data);
        _appPreferences.setUserId(key: "userId", value: loginModel?.id ?? "");
        _appPreferences.getUserId(key: "userId").then((value) {
          Constants.id = value!;
        });
        emit(LoginSuccessState());
        _appPreferences.setToken(key: 'token', value: loginModel?.token ?? "");

        if (kDebugMode) {
          print("userId form login cubit : ${Constants.id}");
        }
        // getUser();
        if (kDebugMode) {
          print(value.toString());

          // getCurrentDriver();
        }
      }).catchError((error) {
        emit(LoginErrorState(error.toString()));
        if (kDebugMode) {
          print("error : $error");

          // showErrorMessage(message: AppStrings.numberOrPasswordInvalid.tr());
        }
      });
    } else {
      showNoInternetMessage();
    }
  }
}
