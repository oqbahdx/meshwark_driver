import 'package:flutter/material.dart';
import 'package:meshwark_driver/presentation/resources/value_manager.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NotificationLoadingScreen extends StatelessWidget {
  const NotificationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 5, // Assuming a list of 5 loading items
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
            child: BuildContainer(height: height, width: width),
          ),
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
      interval: const Duration(seconds: 1),
      color: Colors.white,
      colorOpacity: 0,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: height * 0.14,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p16, vertical: AppPadding.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.025,
                width: width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s30),
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                height: height * 0.015,
                width: width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s30),
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(height: height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height * 0.015,
                    width: width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s30),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Container(
                    height: height * 0.015,
                    width: width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s30),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
