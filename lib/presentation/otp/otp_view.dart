import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshwark_driver/presentation/bloc/otp_bloc/otp_cubit.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class OTPView extends StatefulWidget {
  final String number;

  const OTPView({super.key, required this.number});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  late String otpCode;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OtpCubit>().submitPhoneNumber(phoneNumber: widget.number);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpVerifiedState) {
          Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
        }
      },
      builder: (context, state) {
        var cubit = context.read<OtpCubit>();
        return Scaffold(
          backgroundColor: ColorManager.primary,
          appBar: AppBar(
            iconTheme: IconThemeData(color: ColorManager.white),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                statusBarColor: ColorManager.primary),
            backgroundColor: ColorManager.primary,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: ColorManager.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Text(
                        AppStrings.verificationCode.tr(),
                        style: getBoldStyle(
                            color: ColorManager.black, fontSize: FontSize.s30),
                      ),
                      SizedBox(
                        height: height * 0.2,
                      ),
                      PinCodeTextField(
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            selectedFillColor: ColorManager.lightPrimary,
                            activeFillColor: ColorManager.textFormLightGrey,
                            inactiveFillColor: ColorManager.textFormLightGrey,
                            inactiveColor: ColorManager.lightPrimary,
                            selectedColor: ColorManager.white,
                            activeColor: ColorManager.white,
                            fieldOuterPadding: const EdgeInsets.only(
                                left: AppSize.s8, right: AppSize.s8)),
                        animationDuration: const Duration(milliseconds: 300),
                        // backgroundColor: Colors.blue.shade50,
                        enableActiveFill: true,
                        errorAnimationController: null,
                        controller: _controller,
                        onCompleted: (code) {
                          if (kDebugMode) {
                            print("Completed");
                          }
                          otpCode = code;
                        },
                        onChanged: (value) {
                          if (kDebugMode) {
                            print(value);
                          }
                          setState(() {
                            // currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          if (kDebugMode) {
                            print("Allowing to paste $text");
                          }
                          return true;
                        },
                        appContext: context,
                      ),
                      SizedBox(
                        height: height * 0.2,
                      ),
                      SizedBox(
                          height: height * 0.06,
                          width: width * 0.5,
                          child: ElevatedButton(
                              onPressed: () {
                                cubit.submitOtp(otpCode).then((value) {});
                              },
                              child: Text(
                                AppStrings.verify.tr(),
                                style: getBoldStyle(
                                    color: ColorManager.white,
                                    fontSize: AppSize.s20),
                              ))),
                      SizedBox(
                        height: height * 0.07,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void login(BuildContext context) {
    BlocProvider.of<OtpCubit>(context).submitOtp(otpCode);
  }
}
