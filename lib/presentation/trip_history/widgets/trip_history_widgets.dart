import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';



class TripHistoryWidgets extends StatelessWidget {
  const TripHistoryWidgets({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          "8 Aug12:00 AM",
          style: getBoldStyle(
              color: ColorManager.darkPrimary, fontSize: FontSize.s20),
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.circle_outlined,
              color: ColorManager.darkPrimary,
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Text("Start point",
                style: getBoldStyle(
                    color: ColorManager.darkPrimary, fontSize: FontSize.s16)),
            const Spacer(),
            Icon(
              Icons.circle,
              color: ColorManager.darkPrimary,
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Text("End point",
                style: getBoldStyle(
                    color: ColorManager.darkPrimary, fontSize: FontSize.s16)),
          ],
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.person,
              color: ColorManager.darkPrimary,
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Text("4",
                style: getBoldStyle(
                    color: ColorManager.darkPrimary, fontSize: FontSize.s16)),
            const Spacer(),
            Text("250",
                style: getBoldStyle(
                    color: ColorManager.darkPrimary, fontSize: FontSize.s16)),

            SizedBox(
              width: width * 0.03,
            ),
            Icon(
              Icons.monetization_on_sharp,
              color: ColorManager.darkPrimary,
            ),
          ],
        ),
      ],
    );
  }
}
