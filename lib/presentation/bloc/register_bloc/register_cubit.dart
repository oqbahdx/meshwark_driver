import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/constant.dart';
import 'package:meshwark_driver/app/di.dart';

import '../../../data/network/dio_helper.dart';
import '../../../domain/register_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  final AppPreferences _appPreferences = instance<AppPreferences>();
  FToast fToast = FToast();
  bool isPassword = true;
  // FirebaseAuth auth = FirebaseAuth.instance;
  // late String verificationId;
  // void codeSent(String verificationId, int? resendToken) {
  //   if (kDebugMode) {
  //     print("code sent");
  //   }
  //   this.verificationId = verificationId;
  //   emit(OtpSuccessState());
  // }
  // void codeAutoRetrievalTimeout(String verificationId) {
  //   if (kDebugMode) {
  //     print("code Auto Retrieval Timeout");
  //   }
  // }
  // Future<void> submitPhoneNumber({required String phoneNumber}) async {
  //   emit(OtpLoadingState());
  //   if (kDebugMode) {
  //     print("submitPhoneNumber");
  //   }
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: '+249$phoneNumber',
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // ANDROID ONLY!
  //
  //       // Sign the user in (or link) with the auto-generated credential
  //       await auth.signInWithCredential(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       if (e.code == 'invalid-phone-number') {
  //         if (kDebugMode) {
  //           print('The provided phone number is not valid.');
  //         }
  //       }
  //
  //       // Handle other errors
  //     },
  //     codeSent: codeSent,
  //     codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  //   );
  // }
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
  }

  void makePasswordVisible() {
    isPassword = !isPassword;
    emit(MakePasswordVisibleState());
  }

  RegisterModel? registerModel;
  RegisterErrorModel? registerModelError;

  void register({
    required String number,
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(RegisterLoadingState());
      DioHelper.postData(endPoint: Constants.registerEndPoint, data: {
        "phoneNumber": number,
        "password": password,
        "email": email,
        "role": "Driver",
        "isApproved": false,
        "fcmToken": fcmToken
      }).then((value) {
        registerModel = RegisterModel.fromJson(value?.data);
        emit(RegisterSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
          emit(RegisterErrorState(error.toString()));
          print(error.toString());
          showErrorMessage(message: AppStrings.phoneNumberOrEmailAreToken.tr());
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: AppStrings.noInternetConnection.tr(),
          backgroundColor: ColorManager.error);
    }
  }
}
