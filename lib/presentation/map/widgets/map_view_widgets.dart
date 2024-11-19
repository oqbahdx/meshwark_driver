import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meshwark_driver/app/app_prefs.dart';

import 'package:meshwark_driver/app/constant.dart';
import 'package:meshwark_driver/app/di.dart';
import 'package:meshwark_driver/presentation/bloc/select_service_bloc/select_service_cubit.dart';

import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';

import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/routes_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';
import 'package:meshwark_driver/presentation/resources/value_manager.dart';





class DrawerList extends StatelessWidget {
  DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorManager.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSize.s20.h),

            Card(
              color: ColorManager.white,
              elevation: 0,  // Make it flatter to match modern design
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s10.r),
                side: BorderSide(color: ColorManager.lightGrey, width: 1),
              ),
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.s10.r),
                  image: context.read<SelectServiceCubit>().userModel?.personalImage != null
                      ? DecorationImage(
                    image: CachedNetworkImageProvider(
                      "${context.read<SelectServiceCubit>().userModel?.personalImage}" ?? '',
                    ),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: context.read<SelectServiceCubit>().userModel?.personalImage == null
                    ? Icon(Icons.person, size: 50.r, color: ColorManager.primary)
                    : null,
              ),
            ),
            SizedBox(height: AppSize.s20.h),
            // Drawer list items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: AppStrings.profile.tr(),
                    onTap: () => Navigator.of(context).pushNamed(Routes.driverProfileRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: AppStrings.notifications.tr(),
                    onTap: () => Navigator.of(context).pushNamed(Routes.notificationRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: AppStrings.tripHistory.tr(),
                    onTap: () => Navigator.of(context).pushNamed(Routes.tripHistoryRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_balance_wallet,
                    title: AppStrings.wallet.tr(),
                    onTap: () => Navigator.of(context).pushNamed(Routes.balanceRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent,
                    title: AppStrings.customerSupport.tr(),
                    onTap: () => Navigator.of(context).pushNamed(Routes.customerSupportRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info,
                    title: AppStrings.aboutApp.tr(),
                    onTap: () => Navigator.of(context).pushNamed(Routes.aboutAppRoute),
                  ),
                ],
              ),
            ),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // Drawer item widget
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.lightPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: ColorManager.lightGrey, width: 1),
          ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ColorManager.primary),
            ),
            title: Text(
              title,
              style: getSemiBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Logout button widget
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          elevation: 0,
        ),
        onPressed: () => _showLogoutDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.exit_to_app, color: ColorManager.white),
            SizedBox(width: 10.w),
            Text(
              AppStrings.logout.tr(),
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final AppPreferences appPreferences = instance<AppPreferences>();

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmation.tr()),
        content: Text(AppStrings.logOutMessage.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              appPreferences.resetPreferences();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.loginRoute);
            },
            child: Text(
              AppStrings.logout.tr(),
              style: TextStyle(color: ColorManager.error),
            ),
          ),
        ],
      ),
    );
  }
}



tripAlert({required String message, required Color color}) {
  return Fluttertoast.showToast(msg: message, backgroundColor: color);
}

class RiderCounter extends StatefulWidget {
  const RiderCounter({super.key, required this.height, required this.riders});
  final double height;
  final Widget? riders;

  @override
  State<RiderCounter> createState() => _RiderCounterState();
}

class _RiderCounterState extends State<RiderCounter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      height: widget.height,
      width: double.infinity,
      child: widget.riders,
    );
  }
}

class BuildElevatedButton extends StatelessWidget {
  const BuildElevatedButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color});
  final String text;
  final Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
        width: width * 0.5,
        height: height * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: onTap,
          child: Text(
            text,
            style: getBoldStyle(
                color: ColorManager.white, fontSize: FontSize.s20.sp),
          ),
        ));
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback takeMeToMyLocation;

  const CustomFloatingActionButton({required this.takeMeToMyLocation, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: takeMeToMyLocation,
      backgroundColor: Colors.white,
      tooltip: 'Take me to my location',
      elevation: 10, // Give it more depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18), // Add rounded corners
      ), // Change to white for a more modern look
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Soft shadow
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // Change position of the shadow
            ),
          ],
          gradient: LinearGradient(
            colors: [
              ColorManager.primary,
              ColorManager.primary, // Add a gradient color for a polished effect
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.my_location,
          color: Colors.white, // Ensure the icon remains visible
          size: 30, // Increase size for better visibility
        ),
      ),
    );
  }
}
class ToFinalDestination extends StatelessWidget {
  final VoidCallback takeMeToFinalLocation;

  const ToFinalDestination({required this.takeMeToFinalLocation, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(

        highlightColor: ColorManager.transparent,
        splashColor: ColorManager.transparent,
        onTap: takeMeToFinalLocation,
        child: Container(
          height: 40.h,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Soft shadow
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3), // Change position of the shadow
              ),
            ],
            gradient: LinearGradient(
              colors: [
                ColorManager.white,
                ColorManager.white, // Add a gradient color for a polished effect
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [

              Text(AppStrings.goToFinalLocation.tr(),style: TextStyle(
                  color: ColorManager.primary,fontSize: FontSize.s16.sp,fontWeight: FontWeight.bold),),
               SizedBox(width: 2.w,),
              Icon(Icons.navigation,color: ColorManager.primary,),
            ],
          ),
        ),
      ),
    );
  }
}







class ResponseSnackBar extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const ResponseSnackBar({
    super.key,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.red,
            Colors.redAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

void showModernSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: ResponseSnackBar(
        message: message,
        onClose: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,  // Makes it float above other elements
      duration: const Duration(seconds: 4),
    ),
  );
}
