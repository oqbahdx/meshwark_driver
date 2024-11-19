import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_driver/presentation/bloc/city_map_bloc/city_map_cubit.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDetailsView extends StatelessWidget {
  const TripDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CityMapCubit>();
    double totalAmount =
        cubit.passengers.fold(0.0, (sum, item) => sum + item['amount']);
    double commission = totalAmount * 0.12;
    double totalAfterDiscount = totalAmount - commission;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorManager.white),
        title: Text(
          AppStrings.tripDetails.tr(),
          style: getSemiBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s20.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: ColorManager.primary,
      ),
      body: BlocConsumer<CityMapCubit, CityMapState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildTripHeader(context),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPassengersSection(context, cubit),
                      SizedBox(height: 24.h),
                      _buildPricingSummary(totalAmount, totalAfterDiscount),
                      SizedBox(height: 24.h),
                      _buildActionButton(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripHeader(BuildContext ctx) {
    // Function to handle emergency call
    void makeEmergencyCall() async {
      const emergencyNumber = "999";
      final Uri url = Uri(scheme: 'tel', path: emergencyNumber);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // Show error dialog if call cannot be made
        if(ctx.mounted){
          showDialog(
            context: ctx,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: Text(AppStrings.emergencySituation.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.ok.tr()),
                ),
              ],
            ),
          );
        }

      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Emergency Button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16.h),
            child: ElevatedButton.icon(
              onPressed: makeEmergencyCall,
              icon: Icon(
                Icons.emergency,
                color: Colors.white,
                size: 24.w,
              ),
              label: Text(
                AppStrings.emergencySituation.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Original Content
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: ColorManager.primary,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocationRow(
                        AppStrings.from.tr(),
                        ctx.read<CityMapCubit>().startCitiesItems[
                        ctx.read<CityMapCubit>().currentStartCity],
                        Colors.green),
                    SizedBox(height: 16.h),
                    _buildLocationRow(
                        AppStrings.to.tr(),
                        ctx.read<CityMapCubit>().endCitiesItems[
                        ctx.read<CityMapCubit>().currentEndCity],
                        Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, String city, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
            Text(
              city,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassengersSection(BuildContext context, CityMapCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.passengers.tr(),
          style: TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemCount: cubit.passengers.length,
          itemBuilder: (context, index) {
            final passenger = cubit.passengers[index];
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorManager.primary.withOpacity(0.1),
                    child: Text(
                      passenger['name'][0],
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passenger['name'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${passenger['passengers']} ${AppStrings.passengers.tr()}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${passenger['amount'].toStringAsFixed(2)} ${AppStrings.riyal.tr()}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPricingSummary(double totalAmount, double totalAfterDiscount) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow(
            AppStrings.totalAmount.tr(),
            "${totalAmount.toStringAsFixed(2)} ${AppStrings.riyal.tr()}",
            ColorManager.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(height: 1.h),
          ),
          _buildPriceRow(
            AppStrings.with12Discount.tr(),
            "${totalAfterDiscount.toStringAsFixed(2)} ${AppStrings.riyal.tr()}",
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16.sp,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primary,
            ColorManager.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.finalDestination.tr()),
              backgroundColor: ColorManager.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppStrings.finalDestination.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
