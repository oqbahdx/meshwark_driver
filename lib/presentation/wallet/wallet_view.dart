import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:meshwark_driver/presentation/bloc/wallet_bloc/wallet_cubit.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';

import '../resources/color_manager.dart';

import '../resources/language_manager.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = context.read<WalletCubit>();
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark),
            elevation: 0,
            backgroundColor: ColorManager.transparent,
            title: Text(
              AppStrings.balance.tr(),
              style: TextStyle(
                color: ColorManager.primary,
                fontSize: isRTL() ? 26.sp : 24.sp,
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
                  SizedBox(height: 20.h),
                  _buildMonthSelector(cubit),
                  SizedBox(height: 40.h),
                  _buildBalanceCard(context),
                  SizedBox(height: 30.h),
                  _buildTransactionList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthSelector(WalletCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, color: ColorManager.primary, size: 18.sp),
          SizedBox(width: 8.w),
          DropdownButton<String>(
            value: cubit.monthsItems[cubit.selectedMonth],
            onChanged: (newValue) {
              if (newValue != null) {
                cubit.changeSelectedMonth(cubit.monthsItems.indexOf(newValue));
              }
            },
            items: cubit.monthsItems.map((String month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(
                  month,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
            underline: SizedBox(), // Removes the default underline
            icon: Icon(Icons.arrow_drop_down, color: ColorManager.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.accountBalance.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "${AppStrings.riyal.tr()} 0",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    // Placeholder for transaction list
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: ColorManager.primary.withOpacity(0.1),
              child: Icon(Icons.attach_money, color: ColorManager.primary),
            ),
            title: Text('Transaction ${index + 1}'),
            subtitle:
                Text('Date: ${DateTime.now().toString().substring(0, 10)}'),
            trailing: Text(
              '${AppStrings.riyal.tr()} ${(index + 1) * 100}',
              style: TextStyle(
                color: ColorManager.primary,
                fontWeight: FontWeight.bold,
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
}
