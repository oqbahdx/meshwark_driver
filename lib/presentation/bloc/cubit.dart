import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/constant.dart';
import 'package:meshwark_driver/app/di.dart';
import 'package:meshwark_driver/presentation/bloc/states.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import '../../data/network/dio_helper.dart';
import '../../domain/notification_model.dart';
import '../map/widgets/map_view_widgets.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());
  final AppPreferences _appPreferences = instance<AppPreferences>();

  static AppCubit get(context) => BlocProvider.of(context);

  FToast fToast = FToast();

  final picker = ImagePicker();
  File? personalImage,
      idImage,
      plateImage,
      licenseImage,
      imageProfile,
      insuranceImage;

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

  void resetPersonalImage() {
    personalImage = null;
    emit(RestImageSuccessState());
  }

  void resetInsuranceImage() {
    insuranceImage = null;
    emit(RestImageSuccessState());
  }

  void resetIdImage() {
    idImage = null;
    emit(RestImageSuccessState());
  }

  void resetPlateImage() {
    plateImage = null;
    emit(RestImageSuccessState());
  }

  void resetLicenseImage() {
    licenseImage = null;
    emit(RestImageSuccessState());
  }

  Future getImageProfile(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      imageProfile = File(pickedFile.path);
      emit(UpdatePersonalImageSuccessState());
    }
    if (kDebugMode) {
      print(imageProfile?.path.split('/').last);
    }
    emit(UpdateImageProfileSuccessState());
  }

  void resetImageProfile() {
    imageProfile = File("");
    emit(RestImageSuccessState());
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

  // Future<void> signIn(PhoneAuthCredential credential) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     // emit(OtpVerifiedState());
  //   } catch (e) {
  //     emit(OtpErrorState(e.toString()));
  //   }
  // }

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
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
    "2013",
    "2012",
    "2011",
    "2010"
  ];

  // var yearsItems = [
  //   AppStrings.selectYear.tr(),
  //   "2022",
  //   "2021",
  //   "2020",
  //   "2019",
  //   "2018",
  //   "2017",
  //   "2016",
  //   "2015",
  //   "2014",
  //   "2013",
  //   "2012",
  //   "2011",
  //   "2010"
  // ];
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

  void changeAgreed(bool? value) {
    isAgreed = value!;
    emit(ChangeIsAgreedState());
  }

  void changeYear(String? value) {
    yearsValue = value!;
    emit(ChangeYearOfCarState());
  }

  void changeModel(String? value) {
    modelsValue = value!;
    emit(ChangeModelOfCarState());
  }

  void changeColor(String? value) {
    colorsValue = value!;
    emit(ChangeColorOfCarState());
  }

  void changeRiders(String? value) {
    riderNumberValue = value!;
    emit(ChangeRidersOfCarState());
  }

  bool manIsActive = false;
  bool womanIsActive = false;
  String gender = "";

  void setManIsActive() {
    manIsActive = true;
    womanIsActive = false;
    gender = "man";
    if (kDebugMode) {
      print(gender);
    }
    emit(WomanIsActiveState());
  }

  void setWomanIsActive() {
    manIsActive = false;
    womanIsActive = true;
    gender = "woman";
    if (kDebugMode) {
      print(gender);
    }
    emit(WomanIsActiveState());
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

  bool isStart = false;

  void startTrip() {
    isStart = true;
    emit(CancelTripState());
  }

  void endTrip() {
    isStart = false;
    emit(StartTripState());
  }

  String locationEnd = AppStrings.selectYourDestination;
  var locationEndItems = [
    "Select Your Destination",
    "Riyadh",
    "Jeddah",
    "Makkah",
    "Madinah",
    "Dammam",
    "Taif",
    "Kharj",
    "Khobar",
    "Tabuk",
    "Dhahran",
  ];

  showBottomSheet(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
            height: height * 0.85,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                ColorManager.textFormDarkGrey,
                ColorManager.textFormLightGrey,
                ColorManager.textFormDarkGrey,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Text(
                    "Trip Details",
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s20),
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  Text(
                    "Destination",
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  ),
                  SizedBox(
                    height: height * 0.045,
                  ),
                  DropdownButton(
                      elevation: AppSize.s5,
                      dropdownColor: ColorManager.textFormLightGrey,
                      value: locationEnd,
                      items: locationEndItems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        locationEnd = value!;
                        emit(ChangeCityState());
                      }),
                  SizedBox(
                    height: height * 0.045,
                  ),
                  Text(
                    "Price For Per Rider",
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.25),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: ColorManager.black),
                        labelText: "Price",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.055,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.06,
                        width: width * 0.4,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.error),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s20),
                            )),
                      ),
                      SizedBox(
                        height: height * 0.06,
                        width: width * 0.4,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.teal),
                            onPressed: () {
                              startTrip();
                              Navigator.pop(context);
                              tripAlert(
                                  message: 'waiting for riders now',
                                  color: ColorManager.primary);
                            },
                            child: Text(
                              "Start",
                              style: getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s20),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> addProfile({
    required int userId,
    required String firstName,
    required String middleName,
    required String lastName,
    required String gender,
    required String service,
    required String carModel,
    required String carYear,
    required String carColor,
    required int numberOfSeats,
    required double latitude,
    required double longitude,
    required String carPlate,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // emit(AddProfileLoadingState());
      var data = FormData.fromMap({
        "personal_image": MultipartFile.fromFileSync(personalImage!.path,
            filename:
                "https://test.aqarat-sudan.com/persons_images/${personalImage!.path}"),
        'license_image': MultipartFile.fromFileSync(licenseImage!.path,
            filename:
                "https://test.aqarat-sudan.com/licenses_images/${licenseImage!.path}"),
        'id_image': MultipartFile.fromFileSync(idImage!.path,
            filename:
                "https://test.aqarat-sudan.com/users_ids/${idImage!.path}"),
        'plate_image': MultipartFile.fromFileSync(plateImage!.path,
            filename:
                "https://test.aqarat-sudan.com/plate_images/${plateImage!.path}"),
        'insurance_image': MultipartFile.fromFileSync(insuranceImage!.path,
            filename:
                "https://test.aqarat-sudan.com/insurance_images/${insuranceImage!.path}"),
        "user_id": userId,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "gender": gender,
        "service": service,
        "isOnline": 0,
        "car_model": carModel,
        "car_year": carYear,
        "car_color": carColor,
        "number_of_seats_available": numberOfSeats,
        "number_of_seats_reserved": 0,
        "car_plate": carPlate,
        "next_destination": "0",
        "latitude": latitude,
        "longitude": longitude,
        "is_trip_active": 0,
        "price": "0"
      });

      DioHelper.postDataWithImage(endPoint: "strore-driver-profile", data: data)
          .then((value) {
        // emit(AddProfileSuccessState());
        if (kDebugMode) {
          print(value.toString());
        }
      }).catchError((error) {
        // emit(AddProfileErrorState(error.toString()));
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } else {
      showNoInternetMessage();
    }
  }

  NotificationModel? notificationModel;
  // GetUserModel? userModel;
  // UserNoProfile? userNoProfile;

  // void getUser() async {
  //   emit(GetCurrentDriverLoadingState());
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     // DioHelper.getData(endPoint: 'show-driver?user_id=${Constants.userId}')
  //     //     .then((value) {
  //     //   userModel = GetUserModel.fromJson(value?.data);
  //     //   userNoProfile = UserNoProfile.fromJson(value?.data);
  //     //   _appPreferences.setUserId(key: "id", value: userModel?.id ?? 0);
  //       _appPreferences.getUserId(key: "id").then((value) {
  //         Constants.id = value!;
  //       });
  //       // _appPreferences.setUserId(
  //       //     key: "carSeats", value: userModel?.numberOfSeatsAvailable ?? 0);
  //       _appPreferences.getUserId(key: "carSeats").then((value) {
  //         Constants.carSeats = value!;
  //       });
  //       if (kDebugMode) {
  //         print("id from get user : ${Constants.id}");
  //         print("userId from get user : ${Constants.userId}");
  //         print("car seats from get user : ${Constants.carSeats}");
  //       }
  //       if (kDebugMode) {
  //         print(userModel?.firstName.toString());
  //       }
  //       emit(GetCurrentDriverSuccessState());
  //       if (kDebugMode) {
  //         print("success");
  //       }
  //     }).catchError((error) {
  //       if (kDebugMode) {
  //         print(error.toString());
  //       }
  //       if (kDebugMode) {
  //         print("failure");
  //       }
  //       emit(GetCurrentDriverErrorState(error.toString()));
  //     });
  //   } else {
  //     showNoInternetMessage();
  //   }
}

bool isCar = false;
bool isTruck = false;
bool isVan = false;
bool isComplete = false;

// String service = "";

int selectedMonth = 0;
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

// void showDialog(Widget child, BuildContext ctx) {
//   showCupertinoModalPopup<void>(
//       context: ctx,
//       builder: (BuildContext context) => Container(
//             height: 216,
//             padding: const EdgeInsets.only(top: 6.0),
//             // The Bottom margin is provided to align the popup above the system navigation bar.
//             margin: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             // Provide a background color for the popup.
//             color: CupertinoColors.systemBackground.resolveFrom(context),
//             // Use a SafeArea widget to avoid system overlaps.
//             child: SafeArea(
//               top: false,
//               child: child,
//             ),
//           ));
// }

// void updateProfileWithImage(
//     {required String firstName,
//     required String middleName,
//     required String lastName}) async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile ||
//       connectivityResult == ConnectivityResult.wifi) {
//     // emit(UpdateProfileLoadingState());
//     var data = FormData.fromMap({
//       "personal_image": MultipartFile.fromFileSync(personalImage!.path,
//           filename:
//               "https://test.aqarat-sudan.com/persons_images/${personalImage!.path}"),
//       "first_name": firstName,
//       "middle_name": middleName,
//       "last_name": lastName,
//       "isOnline": 0
//     });
//     DioHelper.postDataWithImage(
//             endPoint: "/update-driver-profile?driver_id=${Constants.id}",
//             data: data)
//         .then((value) {
//       if (kDebugMode) {
//         print(value.toString());
//       }
//       // emit(UpdateProfileSuccessState());
//     }).catchError((error) {
//       // emit(UpdateProfileErrorState(error.toString()));
//     });
//   }
// }

void updateProfile(
    {required String firstName,
    required String middleName,
    required String lastName}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    // emit(UpdateProfileLoadingState());

    DioHelper.postData(
        endPoint: "/update-driver-profile?driver_id=${Constants.id}",
        data: {
          "first_name": firstName,
          "middle_name": middleName,
          "last_name": lastName,
          "isOnline": 0
        }).then((value) {
      if (kDebugMode) {
        print(value.toString());
        // showSuccessMessage(message: AppStrings.updateProfileMessage.tr());
      }
      // emit(UpdateProfileSuccessState());
    }).catchError((error) {
      // emit(UpdateProfileErrorState(error.toString()));
    });
  }
}
