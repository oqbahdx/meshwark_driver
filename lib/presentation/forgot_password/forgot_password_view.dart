import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../login/widgets/login_view_widgets.dart';
import '../resources/Strings_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _phoneController; // Non-nullable

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(); // Initialized in initState
  }

  @override
  void dispose() {
    _phoneController.dispose(); // Properly disposing the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: ColorManager.white,
        ),
        elevation: AppSize.s0,
        backgroundColor: ColorManager.transparent,
        title: Text(
          AppStrings.forgotPassword.tr(),
          style: getBoldStyle(
            color: ColorManager.darkPrimary,
            fontSize: isRTL() ? FontSize.s22.sp : FontSize.s20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.05),
                    Image.asset(
                      ImageAssets.appLogo,
                      height: width * 0.45,
                      width: width * 0.45,
                    ),
                    SizedBox(height: height * 0.15),
                    BuildTextFormFiled(
                      textEditingController: _phoneController,
                      validator: _phoneValidator,
                      textInputType: TextInputType.number,
                      maxLines: 1,
                      labelText: AppStrings.phoneNumber.tr(),
                    ),
                    SizedBox(height: height * 0.2),
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.5,
                      child: ElevatedButton(
                        onPressed: _onResetPasswordPressed,
                        child: Text(
                          AppStrings.resetPassword.tr(),
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: isRTL() ? FontSize.s22.sp : FontSize.s20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.thisFieldIsRequired;
    }
    if (value.length < 10) {
      return AppStrings.errorNumber.tr();
    }
    return null;
  }

  void _onResetPasswordPressed() {
    if (_formKey.currentState?.validate() == true) {
      // TODO: Implement reset password method
    }
  }
}
