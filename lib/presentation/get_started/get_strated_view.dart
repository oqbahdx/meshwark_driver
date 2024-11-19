import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/di.dart';
import 'package:meshwark_driver/presentation/resources/strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/language_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';
import 'package:meshwark_driver/presentation/resources/value_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import '../resources/routes_manager.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    super.initState();
    _appPreferences.setIsBoarding(key: 'boarding', value: 1);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool isRTL() => context.locale == ARABIC_LOCALE;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? widget) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ColorManager.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
            ),
          ),
          body: Stack(
            children: [
              Image.asset(
                ImageAssets.getStarted,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit
                    .cover, // Use cover for better aspect ratio management
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.black.withOpacity(0.3),
                      ColorManager.black.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Transform(
                  transform: Matrix4.translationValues(
                      width * animation.value, 0.0, 0.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.1),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSize.s18.w),
                          child: Align(
                            alignment: isRTL()
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(
                              AppStrings.bestDriver.tr(),
                              style: getBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s28.sp,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSize.s18.w),
                          child: Align(
                            alignment: isRTL()
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(
                              AppStrings.fastAndConvenient.tr(),
                              style: getRegularStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.085),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p20.w),
                          child: Text(
                            AppStrings.splashDescription.tr(),
                            style: getRegularStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s25.sp,
                            ),
                            textAlign: TextAlign.center, // Center the text
                          ),
                        ),
                        SizedBox(height: height * 0.2),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSize.s20.r), // Rounded corners
                            ),
                            shadowColor: ColorManager.grey, // Subtle shadow
                            elevation: 5,
                          ),
                          onPressed: () async {
                            if (await Permission.location.request().isGranted) {
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.loginRoute);
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppStrings.askForLocationMessage.tr(),
                                      style: getSemiBoldStyle(
                                          color: ColorManager.white),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: SizedBox(
                            height: height * 0.06,
                            width: width * 0.5,
                            child: Center(
                              child: Text(
                                AppStrings.getStarted.tr(),
                                style: getBoldStyle(
                                  color: ColorManager.primary,
                                  fontSize: isRTL()
                                      ? FontSize.s22.sp
                                      : FontSize.s20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.09),
                        Padding(
                          padding: EdgeInsets.only(left: 21.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                ImageAssets.languageIc,
                                color: ColorManager.white,
                              ),
                              SizedBox(width: width * 0.02),
                              InkWell(
                                onTap: () {
                                  _appPreferences.changeAppLanguage();
                                  Phoenix.rebirth(context);
                                },
                                child: Text(
                                  AppStrings.changeLanguage.tr(),
                                  style: getBoldStyle(
                                    color: ColorManager.white,
                                    fontSize: isRTL()
                                        ? FontSize.s16.sp
                                        : FontSize.s14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
