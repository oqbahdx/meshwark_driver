import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:meshwark_driver/presentation/customer_support/widgets/customer_support%20_widgets.dart';

import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';

import '../resources/color_manager.dart';

import '../resources/language_manager.dart';

class CustomerSupportView extends StatelessWidget {
  const CustomerSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: ColorManager.transparent,
        title: Text(
          AppStrings.customerSupport.tr(),
          style: TextStyle(
            color: ColorManager.primary,
            fontSize: isRTL(context) ? 24.sp : 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.howCanWeHelp.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.primary,
                ),
              ),
              SizedBox(height: 20.h),
              _buildSupportOption(
                context: context,
                title: AppStrings.whatsApp.tr(),
                icon: ImageAssets.whatsApp,
                color: const Color(0xFF25D366),
                onTap: () => SendMessageToApp.launchWhatsapp(context),
              ),
              SizedBox(height: 16.h),
              _buildSupportOption(
                context: context,
                title: AppStrings.email.tr(),
                icon: Icons.email_outlined,
                color: ColorManager.primary,
                onTap: () =>
                    SendMessageToApp.launchEmail("mailto:oqbahdx@gmail.com"),
              ),
              SizedBox(height: 16.h),
              _buildSupportOption(
                context: context,
                title: AppStrings.faq.tr(),
                icon: Icons.question_answer_outlined,
                color: Colors.orange,
                onTap: () {
                  // Navigate to FAQ page
                },
              ),
              SizedBox(height: 40.h),
              Center(
                child: Text(
                  AppStrings.orContactUs.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorManager.grey,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildContactInfo(
                icon: Icons.phone,
                text: "+1 234 567 890",
              ),
              SizedBox(height: 12.h),
              _buildContactInfo(
                icon: Icons.location_on,
                text: AppStrings.companyAddress.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOption({
    required BuildContext context,
    required String title,
    required dynamic icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: icon is IconData
                  ? Icon(icon, color: color, size: 24.sp)
                  : Image.asset(icon, height: 24.h, width: 24.w, color: color),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.primary,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                size: 16.sp, color: ColorManager.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18.sp, color: ColorManager.primary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.grey,
          ),
        ),
      ],
    );
  }

  bool isRTL(BuildContext context) {
    return context.locale == ARABIC_LOCALE;
  }
}
