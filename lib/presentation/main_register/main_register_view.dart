import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/di.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/routes_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';
import 'package:meshwark_driver/presentation/resources/value_manager.dart';

class MainRegisterView extends StatelessWidget {
  MainRegisterView({super.key});

  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size(0, 0),
      child: AppBar(
        backgroundColor: ColorManager.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.primary.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ImageAssets.splash,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Container(
          color: ColorManager.primary.withOpacity(0.7),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: AppSize.s100.h),
                buildLogo(),
                SizedBox(height: AppSize.s300.h),
                buildButtons(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLogo() {
    return Image.asset(
      ImageAssets.appLogo,
      height: 150.h,
      width: 150.w,
    );
  }

  Widget buildButtons(BuildContext context) {
    return  buildButton(
      text: AppStrings.next.tr(),
      color: ColorManager.primary,
      onTap: () {
        _appPreferences.setMainRegisterScreenViewed();
        Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
      },
    );
  }
  Widget buildButton({required String text, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 120.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSize.s8),
          border: Border.all(width: AppSize.s2, color: ColorManager.white),
        ),
        child: Center(
          child: Text(
            text,
            style: getBoldStyle(color: ColorManager.white, fontSize: FontSize.s18),
          ),
        ),
      ),
    );
  }
}
