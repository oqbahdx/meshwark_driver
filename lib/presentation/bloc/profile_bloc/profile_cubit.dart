import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/di.dart';

import '../../../app/constant.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/user_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final AppPreferences _appPreferences = instance<AppPreferences>();
  FToast fToast = FToast();
  final picker = ImagePicker();
  File? personalImage;
  getPersonalImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      personalImage = File(pickedFile.path);
      emit(UpdatePersonalImageSuccessState());
    }
    if (kDebugMode) {
      print(personalImage?.path.split('/').last);
    }
    emit(UpdatePersonalImageSuccessState());
  }

  deletePersonalImage() {
    personalImage = null;
    emit(DeletePersonalImage());
  }

  UserModel? userModel;
  void updateProfileWithImage(
      {required String firstName, required String lastName}) async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(UpdateProfileLoadingState());
      var data = FormData.fromMap({
        "personalImage": MultipartFile.fromFileSync(personalImage!.path,
            filename: "${personalImage?.path.split('/').last}"),
        "firstName": firstName,
        "lastName": lastName,
      });
      DioHelper.updateDataWithImage(
              endPoint: "${Constants.updateUserEndPoint}/${Constants.id}",
              data: data)
          .then((value) {
        if (kDebugMode) {
          // userModel = GetUserModel.fromJson(value!.data);
          print(value.toString());
          _appPreferences.setFirstName(
              key: 'firstName', value: userModel?.firstName ?? "");
          // _appPreferences.setMiddleName(key: 'middleName', value: userModel?.middleName ?? "");
          _appPreferences.setLastName(
              key: 'lastName', value: userModel?.lastName ?? "");
        }
        emit(UpdateProfileSuccessState());
      }).catchError((error) {
        emit(UpdateProfileErrorState(error.toString()));
      });
    }
  }

  void updateProfile(
      {required String firstName, required String lastName}) async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(UpdateProfileLoadingState());
      var data = FormData.fromMap({
        "firstName": firstName,
        "lastName": lastName,
      });
      DioHelper.updateDataWithImage(
              endPoint: "${Constants.updateUserEndPoint}/${Constants.id}",
              data: data)
          .then((value) {
        if (kDebugMode) {
          // userModel = GetUserModel.fromJson(value!.data);
          print(value.toString());
          _appPreferences.setFirstName(
              key: 'firstName', value: userModel?.firstName ?? "");
          // _appPreferences.setMiddleName(key: 'middleName', value: userModel?.middleName ?? "");
          _appPreferences.setLastName(
              key: 'lastName', value: userModel?.lastName ?? "");
        }
        emit(UpdateProfileSuccessState());
      }).catchError((error) {
        emit(UpdateProfileErrorState(error.toString()));
      });
    }
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

  Widget buildPersonalImageCard(BuildContext context, {required double width}) {
    final hasPersonalImage = personalImage != null;
    // final personalImageURL = "https://wash-stations.com/public/persons_images/${userModel?.personalImage}";
    return Stack(
      children: [
        Card(
          elevation: AppSize.s4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s20)),
          child: SizedBox(
            height: width * 0.3,
            width: width * 0.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s20),
              child: hasPersonalImage
                  ? Image.file(
                      personalImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: "personalImageURL", // todo : remove double qot
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          Image.asset(ImageAssets.appLogo),
                      errorWidget: (context, url, error) =>
                          Image.asset(ImageAssets.appLogo),
                    ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            onPressed: () => getPersonalImage(ImageSource.gallery),
            icon: Icon(
              Icons.edit,
              color: ColorManager.error,
              size: AppSize.s30,
            ),
          ),
        ),
      ],
    );
  }

  getAlertDialog(
      {required Function() onTapCam,
      required Function() onTapGal,
      required BuildContext context}) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s10)),
        backgroundColor: ColorManager.textFormDarkGrey,
        title: Align(
            alignment: Alignment.center,
            child: Text(AppStrings.pleaseSelectImage.tr())),
        elevation: 2,
        actions: [
          InkWell(
            onTap: onTapCam,
            child: Container(
              height: height * 0.065,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppPadding.p12),
                  color: ColorManager.textFormLightGrey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  Text(
                    AppStrings.camera.tr(),
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: onTapGal,
            child: Container(
              height: height * 0.065,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppPadding.p12),
                  color: ColorManager.textFormLightGrey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.image,
                    size: 40,
                  ),
                  Text(
                    AppStrings.gallery.tr(),
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: height * 0.055,
              width: width * 0.75,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.error),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.cancel.tr(),
                    style: getSemiBoldStyle(
                        color: ColorManager.white, fontSize: FontSize.s16),
                  )),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
      context: context,
    );
  }
}
