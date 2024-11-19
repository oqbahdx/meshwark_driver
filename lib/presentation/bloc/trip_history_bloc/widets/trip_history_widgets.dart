import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/value_manager.dart';



class TripHistoryScreenLoading extends StatelessWidget {
  const TripHistoryScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.s10),
        child: ListView(
          children: [
            BuildContainer(height: height, width: width),
            Shimmer(
                duration: const Duration(seconds: 1),
                //Default const value
                interval: const Duration(
                  seconds: 1,
                ),
                //Default value: Duration(seconds: 0)
                color: Colors.white,
                //Default value
                colorOpacity: 0,
                //Default value
                enabled: true,
                //Default value
                direction: const ShimmerDirection.fromLTRB(),
                child: buildDivider()),
            BuildContainer(height: height, width: width),
            Shimmer(
                duration: const Duration(seconds: 1),
                //Default const value
                interval: const Duration(
                  seconds: 1,
                ),
                //Default value: Duration(seconds: 0)
                color: Colors.white,
                //Default value
                colorOpacity: 0,
                //Default value
                enabled: true,
                //Default value
                direction: const ShimmerDirection.fromLTRB(),
                child: buildDivider()),
            BuildContainer(height: height, width: width),
            Shimmer(
                duration: const Duration(seconds: 1),
                //Default const value
                interval: const Duration(
                  seconds: 1,
                ),
                //Default value: Duration(seconds: 0)
                color: Colors.white,
                //Default value
                colorOpacity: 0,
                //Default value
                enabled: true,
                //Default value
                direction: const ShimmerDirection.fromLTRB(),
                child: buildDivider()),
            BuildContainer(height: height, width: width),
            Shimmer(
                duration: const Duration(seconds: 1),
                //Default const value
                interval: const Duration(
                  seconds: 1,
                ),
                //Default value: Duration(seconds: 0)
                color: Colors.white,
                //Default value
                colorOpacity: 0,
                //Default value
                enabled: true,
                //Default value
                direction: const ShimmerDirection.fromLTRB(),
                child: buildDivider()),
            BuildContainer(height: height, width: width),
            Shimmer(
                duration: const Duration(seconds: 1),
                //Default const value
                interval: const Duration(
                  seconds: 1,
                ),
                //Default value: Duration(seconds: 0)
                color: Colors.white,
                //Default value
                colorOpacity: 0,
                //Default value
                enabled: true,
                //Default value
                direction: const ShimmerDirection.fromLTRB(),
                child: buildDivider()),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
      child: Card(
        elevation: 2.0,
        child: Divider(
          color: Colors.grey.shade200,
          thickness: 2,
        ),
      ),
    );
  }
}

class BuildContainer extends StatelessWidget {
  const BuildContainer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 1),
      //Default const value
      interval: const Duration(
        seconds: 1,
      ),
      //Default value: Duration(seconds: 0)
      color: Colors.white,
      //Default value
      colorOpacity: 0,
      //Default value
      enabled: true,
      //Default value
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: height * 0.22,
        color: Colors.grey.shade200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: AppSize.s4, left: AppSize.s4, top: AppSize.s4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height * 0.02,
                    width: width * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(AppSize.s8)),
                  ),
                  Container(
                    height: height * 0.02,
                    width: width * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(AppSize.s4)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Container(
              height: height * 0.035,
              width: width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppPadding.p8),
                  color: Colors.grey.shade300),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.circle_outlined,
                  color: Colors.grey.shade300,
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  height: height * 0.01,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    color: Colors.grey.shade300,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.circle,
                  color: Colors.grey.shade300,
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  height: height * 0.01,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    color: Colors.grey.shade300,
                  ),
                ),
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
                  color: Colors.grey.shade300,
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  height: height * 0.01,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    color: Colors.grey.shade300,
                  ),
                ),
                const Spacer(),
                Container(
                  height: height * 0.01,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Icon(
                  Icons.monetization_on_sharp,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}