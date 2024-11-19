import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/constant.dart';

import 'package:meshwark_driver/app/di.dart';
import 'package:meshwark_driver/domain/user_model.dart';

import '../../../data/network/dio_helper.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'driver_registraion_state.dart';

class DriverRegistrationCubit extends Cubit<DriverRegistraionState> {
  DriverRegistrationCubit() : super(DriverRegistraionInitial());
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final picker = ImagePicker();
  File? personalImage,
      idImage,
      plateImage,
      licenseImage,
      imageProfile,
      insuranceImage;
  Future getPersonalImage(ImageSource src) async {
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

  void resetPersonalImage() {
    personalImage = null;
    emit(RestImageSuccessState());
  }

  Future getIdImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      idImage = File(pickedFile.path);
      emit(UpdatePersonalImageSuccessState());
    }
    if (kDebugMode) {
      print(idImage?.path.split('/').last);
    }
    emit(UpdatePersonalImageSuccessState());
  }

  void resetIdImage() {
    idImage = null;
    emit(RestImageSuccessState());
  }

  Future getPlateImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      plateImage = File(pickedFile.path);
      emit(UpdatePlateImageSuccessState());
    }
    if (kDebugMode) {
      print(plateImage?.path.split('/').last);
    }
    emit(UpdatePlateImageSuccessState());
  }

  void resetPlateImage() {
    plateImage = null;
    emit(RestImageSuccessState());
  }

  Future getLicenseImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      licenseImage = File(pickedFile.path);
      emit(UpdateLicenseImageSuccessState());
    }
    if (kDebugMode) {
      print(licenseImage?.path.split('/').last);
    }
    emit(UpdateLicenseImageSuccessState());
  }

  void resetLicenseImage() {
    licenseImage = null;
    emit(RestImageSuccessState());
  }

  Future getInsuranceImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      insuranceImage = File(pickedFile.path);
      emit(UpdateInsuranceImageImageSuccessState());
    }
    if (kDebugMode) {
      print(insuranceImage?.path.split('/').last);
    }
    emit(UpdateInsuranceImageImageSuccessState());
  }

  void resetInsuranceImage() {
    insuranceImage = null;
    emit(RestImageSuccessState());
  }

  bool isCityActive = false;
  bool isMoveActive = false;
  bool isTruckActive = false;
  String service = "";
  void setCityActive() {
    isCityActive = true;
    isMoveActive = false;
    isTruckActive = false;
    service = "city to city";
    emit(UpdateServiceState());
  }

  void setMovActive() {
    isCityActive = false;
    isMoveActive = true;
    isTruckActive = false;
    service = "move furniture";
    emit(UpdateServiceState());
  }

  void setTruckActive() {
    isCityActive = false;
    isMoveActive = false;
    isTruckActive = true;
    service = "car carrier";
    emit(UpdateServiceState());
  }

  String modelsValue = AppStrings.selectModel.tr();

  var modelsItems = [
    AppStrings.selectModel.tr(),
    AppStrings.toyota.tr(),
    AppStrings.nissan.tr(),
    AppStrings.mercedes.tr(),
    AppStrings.honda.tr(),
    AppStrings.ford.tr(),
    AppStrings.lexus.tr(),
    AppStrings.hyundai.tr(),
    AppStrings.chevrolet.tr(),
    AppStrings.bmw.tr(),
    AppStrings.audi.tr(),
    AppStrings.gmc.tr(),
  ];
  String yearsValue = AppStrings.selectYear.tr();
  int selectedYear = 0;
  int selectedModel = 0;
  int selectedColor = 0;
  int selectedRider = 0;
  List<String> yearsItems = <String>[
    AppStrings.selectYear.tr(),
    "2024",
    "2023",
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
  ];
  String colorsValue = AppStrings.selectColor.tr();

  var colorsItems = [
    AppStrings.selectColor.tr(),
    AppStrings.black.tr(),
    AppStrings.grey.tr(),
    AppStrings.red.tr(),
    AppStrings.blue.tr(),
    AppStrings.silver.tr(),
    AppStrings.brown.tr(),
    AppStrings.green.tr(),
    AppStrings.gold.tr(),
  ];
  String riderNumberValue = AppStrings.selectRider.tr();
  var riderNumberItems = [
    AppStrings.selectRider.tr(),
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8"
  ];
  bool isAgreed = false;
  void showDialog(Widget child, BuildContext ctx) {
    showCupertinoModalPopup<void>(
        context: ctx,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  double kItemExtent = 32.0;
  List<String> dates = <String>[
    AppStrings.today.tr(),
    AppStrings.lastWeek.tr(),
    AppStrings.lastMonth.tr(),
    AppStrings.threeMonth.tr(),
    AppStrings.sixMonth.tr(),
    AppStrings.nineMonth.tr(),
    AppStrings.lastYear.tr(),
    AppStrings.allTime.tr()
  ];

  String monthValue = AppStrings.today.tr();
  var monthsItems = [
    AppStrings.today.tr(),
    AppStrings.lastWeek.tr(),
    AppStrings.lastMonth.tr(),
    AppStrings.threeMonth.tr(),
    AppStrings.sixMonth.tr(),
    AppStrings.nineMonth.tr(),
    AppStrings.lastYear.tr(),
    AppStrings.allTime.tr()
  ];
  bool manIsActive = false;
  bool womanIsActive = false;
  String gender = "";

  void setWomanIsActive() {
    manIsActive = false;
    womanIsActive = true;
    gender = "woman";
    if (kDebugMode) {
      print(gender);
    }
    emit(WomanIsActiveState());
  }

  void setManIsActive() {
    manIsActive = true;
    womanIsActive = false;
    gender = "man";
    if (kDebugMode) {
      print(gender);
    }
    emit(WomanIsActiveState());
  }

  void changeAgreed(bool? value) {
    isAgreed = value!;
    emit(ChangeIsAgreedState());
  }

  UserModel? userModel;
  Future<void> addProfile({
    required String firstName,
    required String lastName,
    required String gender,
    required String typeOfTrip,
    required String carModel,
    required String carYear,
    required String carColor,
    required int numberOfSeats,
    required double latitude,
    required double longitude,
    required String carPlate,
  }) async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(AddProfileLoadingState());
      var data = FormData.fromMap({
        'personalImage': MultipartFile.fromFileSync(
          personalImage?.path ?? "",
          filename: personalImage?.path.split("/").last.replaceAll(' ', '_'),
        ),
        'licenseImage': MultipartFile.fromFileSync(
          licenseImage?.path ?? "",
          filename: licenseImage?.path.split("/").last.replaceAll(' ', '_'),
        ),
        'idImage': MultipartFile.fromFileSync(
          idImage?.path ?? "",
          filename: idImage?.path.split("/").last.replaceAll(' ', '_'),
        ),
        'plateImage': MultipartFile.fromFileSync(
          plateImage?.path ?? "",
          filename: plateImage?.path.split("/").last.replaceAll(' ', '_'),
        ),
        'insuranceImage': MultipartFile.fromFileSync(
          insuranceImage?.path ?? "",
          filename: insuranceImage?.path.split("/").last.replaceAll(' ', '_'),
        ),
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "typeOfTrip": "",
        "isOnline": false,
        "rating": 0.0,
        "completedTrips": 0,
        "carModel": carModel,
        "carYear": carYear,
        "carColor": carColor,
        "availableSeats": numberOfSeats,
        "reservedSeats": 0,
        "numberPlate": carPlate,
        "nextDestination": "",
        "latitude": latitude,
        "isActive": true,
        "longitude": longitude,
        "isApproved": false,
        "isTripActive": false,
      });

      DioHelper.updateDataWithImage(
              endPoint: "${Constants.updateUserEndPoint}/${Constants.id}",
              data: data)
          .then((value) {
        emit(AddProfileSuccessState());
        if (kDebugMode) {
          print(value.toString());
          userModel = UserModel.fromJson(value!.data);
          _appPreferences.setFirstName(
              key: 'firstName', value: userModel?.firstName ?? "");

          _appPreferences.setLastName(
              key: 'lastName', value: userModel?.lastName ?? "");
        }
      }).catchError((error) {
        emit(AddProfileErrorState(error.toString()));
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } else {
      showNoInternetMessage();
    }
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

  getAlertDialog({
    required Function() onTapCam,
    required Function() onTapGal,
    required BuildContext context,
  }) {
    final size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: ColorManager.textFormDarkGrey,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.pleaseSelectImage.tr(),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: onTapCam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.textFormLightGrey,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                icon: Icon(Icons.camera_alt, color: ColorManager.black),
                label: Text(
                  AppStrings.camera.tr(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: onTapGal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.textFormLightGrey,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                icon: Icon(Icons.image, color: ColorManager.black),
                label: Text(
                  AppStrings.gallery.tr(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.error,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  AppStrings.cancel.tr(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
