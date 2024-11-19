
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';

import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class ReviewAccountView extends StatefulWidget {
  const ReviewAccountView({super.key});

  @override
  State<ReviewAccountView> createState() => _ReviewAccountViewState();
}

class _ReviewAccountViewState extends State<ReviewAccountView> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: ColorManager.white),
        elevation: AppSize.s0,
        backgroundColor: ColorManager.transparent,
        title: Text(
          AppStrings.reviewAccount.tr(),
          style: getBoldStyle(
              color: ColorManager.primary, fontSize: FontSize.s16.sp),
        ),
        leading: Container(),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.055,
            ),
            Text(
              AppStrings.completingAccountMessage.tr(),
              style: getBoldStyle(
                  color: ColorManager.primary, fontSize: FontSize.s16.sp),

            ),
            SizedBox(
              height: height * 0.05,
            ),
            Text(
              AppStrings.yourAccountUnderProcessing.tr(),
              style: getBoldStyle(
                  color: ColorManager.primary, fontSize: FontSize.s16.sp),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Lottie.asset(JsonAssets.reviewAccount),
          ],
        ),
      )),
    );
  }
}
