import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/assets_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/color_manager.dart';
import '../resources/language_manager.dart';

class AboutAppView extends StatefulWidget {
  const AboutAppView({Key? key}) : super(key: key);

  @override
  State<AboutAppView> createState() => _AboutAppViewState();
}

class _AboutAppViewState extends State<AboutAppView> {
  String? version;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 40.h),
                  _buildLogo(),
                  SizedBox(height: 24.h),
                  _buildAppName(),
                  SizedBox(height: 8.h),
                  _buildVersion(),
                  SizedBox(height: 40.h),
                  _buildDescription(),
                  SizedBox(height: 40.h),
                  _buildFeatureSection(),
                  SizedBox(height: 40.h),
                  _buildSocialLinks(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      iconTheme: IconThemeData(color: ColorManager.white),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: ColorManager.primary,
      elevation: 0,
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppStrings.aboutApp.tr(),
          style: TextStyle(
            color: ColorManager.white,
            fontSize: isRTL() ? 24.sp : 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorManager.primary,
                ColorManager.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorManager.primary,
              ColorManager.primary.withOpacity(0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            ImageAssets.appLogo,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Center(
      child: Text(
        AppStrings.meshwarkDriver.tr(),
        style: TextStyle(
          color: ColorManager.primary,
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVersion() {
    return Center(
      child: Text(
        '${AppStrings.version.tr()}: ${version ?? ""}',
        style: TextStyle(
          color: ColorManager.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorManager.textFormLightGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        AppStrings.appDescription.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorManager.black,
          fontSize: 16.sp,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeatureTitle(AppStrings.appFeatures.tr()),
        SizedBox(height: 24.h),
        _buildFeatureGrid([
          FeatureItem(
            icon: FontAwesomeIcons.map,
            title: AppStrings.tripTracking.tr(),
            description: AppStrings.tripTrackingDescription.tr(),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.clock,
            title: AppStrings.timeManagement.tr(),
            description: AppStrings.timeManagementDescription.tr(),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.solidStar,
            title: AppStrings.ratings.tr(),
            description: AppStrings.ratingsDescription.tr(),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.route,
            title: AppStrings.multiRoutes.tr(),
            description: AppStrings.multiRoutesDescription.tr(),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.truck,
            title: AppStrings.transportServices.tr(),
            description: AppStrings.transportServicesDescription.tr(),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.carSide,
            title: AppStrings.carsServices.tr(),
            description: AppStrings.carsServicesDescription.tr(),
          ),
        ]),
      ],
    );
  }

  Widget _buildFeatureTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ColorManager.primary,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFeatureGrid(List<FeatureItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index].build();
      },
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(FontAwesomeIcons.facebook, () => _launchUrl('https://www.facebook.com')),
        SizedBox(width: 24.w),
        _socialIcon(FontAwesomeIcons.twitter, () => _launchUrl('https://www.twitter.com')),
        SizedBox(width: 24.w),
        _socialIcon(FontAwesomeIcons.globe, () => _launchUrl('https://www.website.com')),
      ],
    );
  }

  Widget _socialIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorManager.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: ColorManager.primary, size: 24.sp),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }

    }
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  Widget build() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.textFormLightGrey,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.white,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ColorManager.primary,
            size: 32.sp,
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.primary,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.black,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}