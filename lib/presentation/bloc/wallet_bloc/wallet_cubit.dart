import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../resources/Strings_manager.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());
  int selectedMonth = 0;
  double kItemExtent = 32.0;
  List<String> dates = <String>[
    AppStrings.today.tr(),
    AppStrings.lastWeek.tr(),
    AppStrings.lastMonth.tr(),
    AppStrings.threeMonth.tr(),
    AppStrings.sixMonth.tr(),
    AppStrings.nineMonth.tr(),
    AppStrings.lastYear.tr(),
    AppStrings.allTime.tr()
  ];

  String monthValue = AppStrings.today.tr();
  var monthsItems = [
    AppStrings.today.tr(),
    AppStrings.lastWeek.tr(),
    AppStrings.lastMonth.tr(),
    AppStrings.threeMonth.tr(),
    AppStrings.sixMonth.tr(),
    AppStrings.nineMonth.tr(),
    AppStrings.lastYear.tr(),
    AppStrings.allTime.tr()
  ];
  void changeSelectedMonth(int newIndex) {
    selectedMonth = newIndex;
    emit(MonthChangedState()); // Ensure this triggers UI updates
  }

  void showDialog(Widget child, BuildContext ctx) {
    showCupertinoModalPopup<void>(
        context: ctx,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}
