

import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

class BuildContainerType extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const BuildContainerType({
    super.key,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.s8), // Added ripple effect clipping
      child: Container(
        height: size.height * 0.045,
        width: size.width * 0.3,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        alignment: Alignment.center, // Simplified child centering
        child: Text(
          text,
          style: getSemiBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s16,
          ),
        ),
      ),
    );
  }
}


class BuildText extends StatelessWidget {
  const BuildText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Slightly increased elevation for more depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Modern and softer corners
      ),
      shadowColor: Colors.black.withOpacity(0.2), // Softer shadow color
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Added padding for better spacing
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center, // Ensures text is centered properly
          style: getSemiBoldStyle(
            color: ColorManager.primary,
            fontSize: FontSize.s16.sp,
          ),
        ),
      ),
    );
  }
}



class BuildSelectImage extends StatelessWidget {
  const BuildSelectImage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: () {
        // getAlertDialog(onTapCam: (){}, onTapGal: (){}, context: context);
      },
      child: Container(
        height: height * 0.13,
        width: width * 0.55,
        decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.primary,
            ),
            color: ColorManager.textFormLightGrey,
            borderRadius: BorderRadius.circular(AppPadding.p12)),
        child: Icon(
          Icons.add,
          size: 50,
          color: ColorManager.primary,
        ),
      ),
    );
  }
}




class BuildCard extends StatelessWidget {
  const BuildCard({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
  });

  final double height;
  final double width;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * 0.18,
        width: width * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.primary,
              ColorManager.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.add_circle,
                color: Colors.white.withOpacity(0.85),
                size: 48,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.white.withOpacity(0.85),
                    size: 60,
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BuildCardImage extends StatelessWidget {
  const BuildCardImage({
    super.key,
    required this.height,
    required this.width,
    required this.file,
    required this.onTap,
  });

  final double height;
  final double width;
  final File file;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height * 0.18,
          width: width * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.file(
              file,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.delete,
                color: ColorManager.error,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
