import 'package:flutter/material.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';



class BuildTextForm extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLength;
  final String labelText;
  final IconData icn;
  final TextInputType textInputType;
  const BuildTextForm({super.key, required this.controller, this.maxLength, required this.labelText, required this.icn, required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: getSemiBoldStyle(
          color: ColorManager.grey, fontSize: FontSize.s20),
      keyboardType: textInputType,
      textAlign: TextAlign.end,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: ColorManager.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: ColorManager.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        fillColor: ColorManager.textFormLightGrey,
        filled: true,
        focusedBorder: InputBorder.none,
        labelText: labelText,
        hintText: labelText,
        suffixIcon:  Icon(icn),
        iconColor: ColorManager.darkPrimary,
      ),
    );
  }
}

class DriverLoadingScreen extends StatelessWidget {
  const DriverLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Shimmer(
                    duration: const Duration(seconds: 1), //Default const value
                    interval: const Duration(seconds: 1,), //Default value: Duration(seconds: 0)
                    color: Colors.white, //Default value
                    colorOpacity: 0, //Default value
                    enabled: true, //Default value
                    direction: const ShimmerDirection.fromLTRB(),  //Default Value
                    child: Container(
                      height: width *0.3,
                      width: width *0.3,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(AppSize.s100)
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                    child: Shimmer(
                      duration: const Duration(seconds: 1), //Default const value
                      interval: const Duration(seconds: 1,), //Default value: Duration(seconds: 0)
                      color: Colors.white, //Default value
                      colorOpacity: 0, //Default value
                      enabled: true, //Default value
                      direction: const ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        height: width *0.12,
                        width: width ,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                    child: Shimmer(
                      duration: const Duration(seconds: 1), //Default const value
                      interval: const Duration(seconds: 1,), //Default value: Duration(seconds: 0)
                      color: Colors.white, //Default value
                      colorOpacity: 0, //Default value
                      enabled: true, //Default value
                      direction: const ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        height: width *0.12,
                        width: width ,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                    child: Shimmer(
                      duration: const Duration(seconds: 1), //Default const value
                      interval: const Duration(seconds: 1,), //Default value: Duration(seconds: 0)
                      color: Colors.white, //Default value
                      colorOpacity: 0, //Default value
                      enabled: true, //Default value
                      direction: const ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        height: width *0.12,
                        width: width ,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                    child: Shimmer(
                      duration: const Duration(seconds: 1), //Default const value
                      interval: const Duration(seconds: 1,), //Default value: Duration(seconds: 0)
                      color: Colors.white, //Default value
                      colorOpacity: 0, //Default value
                      enabled: true, //Default value
                      direction: const ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        height: width *0.12,
                        width: width ,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Shimmer(
                    duration: const Duration(seconds: 1), //Default const value
                    interval: const Duration(seconds: 1,), //Default value: Duration(seconds: 0)
                    color: Colors.white, //Default value
                    colorOpacity: 0, //Default value
                    enabled: true, //Default value
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(AppSize.s8)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}