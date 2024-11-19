import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_driver/main.dart';

import 'package:meshwark_driver/presentation/bloc/register_bloc/register_cubit.dart';

import 'package:meshwark_driver/presentation/resources/assets_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';

import '../login/widgets/login_view_widgets.dart';
import '../resources/Strings_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController? _passwordController;
  TextEditingController? _emailController;
  TextEditingController? _numberController;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool genderM = false;
  bool genderF = false;
  late String gender;

  // void numberVerify(BuildContext context) {
  //   BlocProvider.of<RegisterCubit>(context)
  //       .submitPhoneNumber(phoneNumber: _numberController!.text.substring(1));
  // }

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().fToast.init(context);
    _emailController = TextEditingController();
    _numberController = TextEditingController();
    _passwordController = TextEditingController();
    print("fcm token from register page : $fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    var cubit = context.read<RegisterCubit>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.s28.h),
        child: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: ColorManager.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: ColorManager.white),
        ),
      ),
      backgroundColor: ColorManager.white,
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          }
          if (state is RegisterErrorState) {
            cubit.showErrorMessage(
                message: AppStrings.phoneNumberOrEmailAreToken.tr());
            // todo: call methode after build is done
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSize.s28),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        Image.asset(
                          ImageAssets.appLogo,
                          height: width * 0.45,
                          width: width * 0.45,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        BuildTextFormFiled(

                          maxLines: 1,

                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return AppStrings.thisFieldIsRequired.tr();
                            }
                            if (value.length < 10) {
                              return AppStrings.errorNumber.tr();
                            }
                            return null;
                          },
                          textEditingController: _numberController!,

                          textInputType: TextInputType.number, labelText: AppStrings.phoneNumber.tr(),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        BuildTextFormFiled(

                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return AppStrings.thisFieldIsRequired.tr();
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_emailController!.text);
                            if (!emailValid) {
                              return AppStrings.emailInvalid.tr();
                            }

                            return null;
                          },
                          textEditingController: _emailController!,

                          textInputType: TextInputType.emailAddress, labelText: AppStrings.email.tr(),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        BuildTextFormFiled(
                          isSecure: cubit.isPassword,
                          maxLines: 1,

                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return AppStrings.thisFieldIsRequired.tr();
                            }
                            return null;
                          },
                          textEditingController: _passwordController!,

                          textInputType: TextInputType.text, labelText: AppStrings.password.tr(),
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        SizedBox(
                          height: height * 0.065,
                          width: width * 0.50,
                          child: state is RegisterLoadingState
                              ? Center(
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation(
                                        ColorManager.primary),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_globalKey.currentState!.validate()) {
                                      cubit.register(
                                          number: _numberController!.text,
                                          email: _emailController!.text.trim(),
                                          password:
                                              _passwordController!.text.trim(),
                                          fcmToken: fcmToken.toString());
                                    }
                                  },
                                  child: Text(
                                    AppStrings.signUp.tr(),
                                    style: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: isRTL()
                                            ? FontSize.s22.sp
                                            : FontSize.s20.sp),
                                  )),
                        ),
                        SizedBox(height: height * 0.042),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(AppStrings.doYouHaveAnAccount.tr(),
                                style: getBoldStyle(
                                    color: ColorManager.darkGrey,
                                    fontSize: isRTL()
                                        ? FontSize.s18.sp
                                        : FontSize.s16.sp)),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppStrings.login.tr(),
                                style: getBoldStyle(
                                    color: ColorManager.primary,
                                    fontSize: isRTL()
                                        ? FontSize.s18.sp
                                        : FontSize.s16.sp),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  @override
  void dispose() {
    _numberController!.dispose();
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }
}
