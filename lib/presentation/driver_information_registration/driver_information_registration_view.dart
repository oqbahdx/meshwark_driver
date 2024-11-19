import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:meshwark_driver/presentation/bloc/driver_registraion_bloc/driver_registraion_cubit.dart';
import 'package:meshwark_driver/presentation/driver_information_registration/widgets/driver_information_widget.dart';

import '../login/widgets/login_view_widgets.dart';
import '../resources/Strings_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class DriverInformationRegistrationView extends StatefulWidget {
  const DriverInformationRegistrationView({super.key});

  @override
  State<DriverInformationRegistrationView> createState() =>
      _DriverInformationRegistrationViewState();
}

class _DriverInformationRegistrationViewState
    extends State<DriverInformationRegistrationView> {
  TextEditingController? _firstNameController;

  TextEditingController? _lastNameController;

  TextEditingController? _plateNumberController;

  final ValueNotifier<int> _isOnline = ValueNotifier<int>(0);
  final _formKey = GlobalKey<FormState>();
  double? lat, lon;

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lon = position.longitude;
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    context.read<DriverRegistrationCubit>().fToast.init(context);
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _plateNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return BlocConsumer<DriverRegistrationCubit, DriverRegistraionState>(
      listener: (context, state) {
        if (state is AddProfileSuccessState) {
          Navigator.of(context).pushReplacementNamed(Routes.reviewAccountRoute);
        }
      },
      builder: (context, state) {
        var cubit = context.read<DriverRegistrationCubit>();
        return Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
              forceMaterialTransparency: true,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: ColorManager.white),
              elevation: AppSize.s0,
              backgroundColor: ColorManager.transparent,
              title: Text(
                AppStrings.driverRegistration.tr(),
                style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: isRTL() ? FontSize.s22.sp : FontSize.s20.sp),
              ),
              leading: Container(),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildTextFormFiled(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return AppStrings.thisFieldIsRequired.tr();
                          }
                          if (value.length < 2) {
                            return AppStrings.firstNameError.tr();
                          }
                          return null;
                        },
                        textEditingController: _firstNameController!,
                        textInputType: TextInputType.text,
                        labelText: AppStrings.firstName.tr(),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildTextFormFiled(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return AppStrings.thisFieldIsRequired.tr();
                          }
                          if (value.length < 2) {
                            return AppStrings.lastNameError.tr();
                          }
                          return null;
                        },
                        textEditingController: _lastNameController!,
                        textInputType: TextInputType.text,
                        labelText: AppStrings.lastName.tr(),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildText(text: AppStrings.personalImage.tr()),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      cubit.personalImage == null
                          ? BuildCard(
                              height: height,
                              width: width,
                              onTap: () {
                                cubit.getAlertDialog(
                                    onTapCam: () {
                                      cubit
                                          .getPersonalImage(ImageSource.camera)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    onTapGal: () {
                                      cubit
                                          .getPersonalImage(ImageSource.gallery)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    context: context);
                              })
                          : BuildCardImage(
                              height: height,
                              width: width,
                              file: cubit.personalImage!,
                              onTap: () {
                                cubit.resetPersonalImage();
                              }),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildText(text: AppStrings.idImage.tr()),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      cubit.idImage == null
                          ? BuildCard(
                              height: height,
                              width: width,
                              onTap: () {
                                cubit.getAlertDialog(
                                    onTapCam: () {
                                      cubit
                                          .getIdImage(ImageSource.camera)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    onTapGal: () {
                                      cubit
                                          .getIdImage(ImageSource.gallery)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    context: context);
                              })
                          : BuildCardImage(
                              height: height,
                              width: width,
                              file: cubit.idImage!,
                              onTap: () {
                                cubit.resetIdImage();
                              }),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildText(text: AppStrings.plateImage.tr()),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      cubit.plateImage == null
                          ? BuildCard(
                              height: height,
                              width: width,
                              onTap: () {
                                cubit.getAlertDialog(
                                    onTapCam: () {
                                      cubit
                                          .getPlateImage(ImageSource.camera)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    onTapGal: () {
                                      cubit
                                          .getPlateImage(ImageSource.gallery)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    context: context);
                              })
                          : BuildCardImage(
                              height: height,
                              width: width,
                              file: cubit.plateImage!,
                              onTap: () {
                                cubit.resetPlateImage();
                              }),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildText(text: AppStrings.licenseImage.tr()),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      cubit.licenseImage == null
                          ? BuildCard(
                              height: height,
                              width: width,
                              onTap: () {
                                cubit.getAlertDialog(
                                    onTapCam: () {
                                      cubit
                                          .getLicenseImage(ImageSource.camera)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    onTapGal: () {
                                      cubit
                                          .getLicenseImage(ImageSource.gallery)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    context: context);
                              })
                          : BuildCardImage(
                              height: height,
                              width: width,
                              file: cubit.licenseImage!,
                              onTap: () {
                                cubit.resetLicenseImage();
                              }),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      BuildText(text: AppStrings.insurance.tr()),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      cubit.insuranceImage == null
                          ? BuildCard(
                              height: height,
                              width: width,
                              onTap: () {
                                cubit.getAlertDialog(
                                    onTapCam: () {
                                      cubit
                                          .getInsuranceImage(ImageSource.camera)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    onTapGal: () {
                                      cubit
                                          .getInsuranceImage(
                                              ImageSource.gallery)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    context: context);
                              })
                          : BuildCardImage(
                              height: height,
                              width: width,
                              file: cubit.insuranceImage!,
                              onTap: () {
                                cubit.resetInsuranceImage();
                              }),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     BuildContainerType(
                      //         text: AppStrings.cityToCity.tr(),
                      //         color: cubit.isCityActive
                      //             ? ColorManager.darkPrimary
                      //             : ColorManager.lightPrimary,
                      //         onTap: () {
                      //           cubit.setCityActive();
                      //         }),
                      //     BuildContainerType(
                      //         text: AppStrings.moveFurniture.tr(),
                      //         color: cubit.isMoveActive
                      //             ? ColorManager.darkPrimary
                      //             : ColorManager.lightPrimary,
                      //         onTap: () {
                      //           cubit.setMovActive();
                      //         }),
                      //     BuildContainerType(
                      //         text: AppStrings.carCarrier.tr(),
                      //         color: cubit.isTruckActive
                      //             ? ColorManager.darkPrimary
                      //             : ColorManager.lightPrimary,
                      //         onTap: () {
                      //           cubit.setTruckActive();
                      //         }),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: height * 0.05,
                      // ),
                      BuildTextFormFiled(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return AppStrings.thisFieldIsRequired.tr();
                          }
                          return null;
                        },
                        textEditingController: _plateNumberController!,
                        textInputType: TextInputType.text,
                        labelText: AppStrings.plateNumber.tr(),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            AppStrings.year.tr(),
                            style: getSemiBoldStyle(
                                color: ColorManager.darkPrimary,
                                fontSize: isRTL()
                                    ? FontSize.s18.sp
                                    : FontSize.s16.sp),
                          ),
                          customDropdown(
                            value: cubit.yearsValue,
                            items: cubit.yearsItems,
                            onChanged: (String? value) {
                              setState(() {
                                cubit.yearsValue = value!;
                              });
                            },
                          ),
                          Text(
                            AppStrings.model.tr(),
                            style: getSemiBoldStyle(
                                color: ColorManager.darkPrimary,
                                fontSize: isRTL()
                                    ? FontSize.s18.sp
                                    : FontSize.s16.sp),
                          ),
                          customDropdown(
                            value: cubit.modelsValue,
                            items: cubit.modelsItems,
                            onChanged: (String? value) {
                              setState(() {
                                cubit.modelsValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            AppStrings.color.tr(),
                            style: getSemiBoldStyle(
                                color: ColorManager.darkPrimary,
                                fontSize: isRTL()
                                    ? FontSize.s18.sp
                                    : FontSize.s16.sp),
                          ),
                          customDropdown(
                            value: cubit.colorsValue,
                            items: cubit.colorsItems,
                            onChanged: (String? value) {
                              setState(() {
                                cubit.colorsValue = value!;
                              });
                            },
                          ),
                          Text(
                            AppStrings.riders.tr(),
                            style: getSemiBoldStyle(
                                color: ColorManager.darkPrimary,
                                fontSize: isRTL()
                                    ? FontSize.s18.sp
                                    : FontSize.s16.sp),
                          ),
                          customDropdown(
                            value: cubit.riderNumberValue,
                            items: cubit.riderNumberItems,
                            onChanged: (String? value) {
                              setState(() {
                                cubit.riderNumberValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cubit.setWomanIsActive();
                              if (kDebugMode) {
                                print("gender : ${cubit.gender}");
                              }
                            },
                            child: Container(
                              height: height * 0.27,
                              width: width * 0.44,
                              decoration: BoxDecoration(
                                color: cubit.womanIsActive
                                    ? ColorManager.primary
                                    : ColorManager.textFormLightGrey,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: cubit.womanIsActive
                                        ? ColorManager.primary.withOpacity(0.2)
                                        : Colors.black12,
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.woman.tr(),
                                      style: TextStyle(
                                        color: cubit.womanIsActive
                                            ? ColorManager.white
                                            : ColorManager.primary,
                                        fontSize: FontSize.s22.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Expanded(
                                      child: Hero(
                                        tag: AppStrings.woman,
                                        child: Image.asset(
                                          ImageAssets.woman,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cubit.setManIsActive();
                              if (kDebugMode) {
                                print("gender : ${cubit.gender}");
                              }
                            },
                            child: Container(
                              height: height * 0.27,
                              width: width * 0.44,
                              decoration: BoxDecoration(
                                color: cubit.manIsActive
                                    ? ColorManager.primary
                                    : ColorManager.textFormLightGrey,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: cubit.manIsActive
                                        ? ColorManager.primary.withOpacity(0.2)
                                        : Colors.black12,
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.man.tr(),
                                      style: TextStyle(
                                        color: cubit.manIsActive
                                            ? ColorManager.white
                                            : ColorManager.primary,
                                        fontSize: FontSize.s22.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Expanded(
                                      child: Hero(
                                        tag: AppStrings.man,
                                        child: Image.asset(
                                          ImageAssets.man,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: ColorManager.primary,
                            value: cubit.isAgreed,
                            onChanged: (value) {
                              cubit.changeAgreed(value);
                              if (kDebugMode) {
                                print(value);
                                print(cubit.isAgreed);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            side: BorderSide(
                              color: ColorManager.primary,
                              width: 2.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                cubit.changeAgreed(!cubit.isAgreed);
                              },
                              child: Text(
                                AppStrings.iAgreeToTerms.tr(),
                                style: TextStyle(
                                  color: ColorManager.primary,
                                  fontSize: FontSize.s16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      SizedBox(
                        height: height * 0.06,
                        width: width * 0.5,
                        child: state is AddProfileLoadingState
                            ? CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorManager.white),
                              )
                            :ElevatedButton(
                          onPressed: () {
                            if (!cubit.isAgreed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppStrings.mustAgreeToTerms.tr(),
                                    style: getRegularStyle(color: ColorManager.primary),
                                  ),
                                  backgroundColor: ColorManager.textFormLightGrey,
                                ),
                              );
                              return;
                            }

                            if (_formKey.currentState?.validate() != null &&
                                cubit.riderNumberValue != AppStrings.selectRider.tr() &&
                                cubit.modelsValue != AppStrings.selectModel.tr() &&
                                cubit.yearsValue != AppStrings.selectYear.tr() &&
                                cubit.colorsValue != AppStrings.selectColor.tr() &&
                                cubit.gender.isNotEmpty &&
                                cubit.idImage != null &&
                                cubit.licenseImage != null &&
                                cubit.plateImage != null &&
                                cubit.personalImage != null) {
                              cubit.addProfile(
                                firstName: _firstNameController!.text,
                                lastName: _lastNameController!.text,
                                gender: cubit.gender,
                                typeOfTrip: "",
                                carModel: cubit.modelsValue,
                                carYear: cubit.yearsValue,
                                carColor: cubit.colorsValue,
                                numberOfSeats: int.parse(cubit.riderNumberValue),
                                latitude: lat ?? 0.0,
                                longitude: lon ?? 0.0,
                                carPlate: _plateNumberController!.text,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppStrings.pleaseFillAllFields.tr(),
                                    style: getSemiBoldStyle(color: ColorManager.primary),
                                  ),
                                  backgroundColor: ColorManager.textFormLightGrey,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cubit.isAgreed
                                ? ColorManager.primary
                                : ColorManager.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppStrings.signUp.tr(),
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: isRTL() ? FontSize.s22 : FontSize.s20,
                            ),
                          ),
                        )
                        ,
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                )),
              ),
            ));
      },
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  @override
  void dispose() {
    _firstNameController!.dispose();
    _lastNameController!.dispose();
    _plateNumberController!.dispose();
    super.dispose();
  }

  Widget customDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: ColorManager.textFormLightGrey,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          elevation: 8,
          dropdownColor: ColorManager.textFormLightGrey,
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: ColorManager.primary),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: ColorManager.primary),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
