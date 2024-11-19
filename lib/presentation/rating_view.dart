import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';

class RatingView extends StatefulWidget {
  const RatingView({super.key});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.close,color: ColorManager.error,)),
        title: Text(
          AppStrings.rating.tr(),
          style: getSemiBoldStyle(
              color: ColorManager.primary, fontSize: FontSize.s20.sp),
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(height: 25.h),
              Text(AppStrings.howWasYourExperience.tr(),
                  style: getSemiBoldStyle(
                      color: ColorManager.black, fontSize: FontSize.s20.sp)),
              SizedBox(height: 30.h),

              // Rating bar
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
             SizedBox(height: 25.h),

              AnimatedOpacity(
                opacity: _rating > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _getRatingText(),
                  style: getSemiBoldStyle(color:_getRatingColor(),fontSize: FontSize.s16.sp),
                ),
              ),
             SizedBox(height: 30.h),

              // Optional comment box
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _rating > 0 ? null : 0,
                child: TextField(
                  style: getMediumStyle(color: ColorManager.black, fontSize: FontSize.s14.sp),
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: AppStrings.leaveComment.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                           BorderSide(color: ColorManager.primary, width: 2),
                    ),
                  ),
                ),
              ),
               SizedBox(height: 100.h),

              // Submit button
              AnimatedOpacity(
                opacity: _rating > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: SizedBox(
                  width: 250.w,
                  child: ElevatedButton(
                    onPressed: _rating > 0 ? _submitRating : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child:  Text(
                      AppStrings.submit.tr(),
                      style: getMediumStyle(color: ColorManager.white, fontSize: FontSize.s16.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText() {
    if (_rating <= 1) return AppStrings.poor.tr();
    if (_rating <= 2) return AppStrings.fair.tr();
    if (_rating <= 3) return AppStrings.good.tr();
    if (_rating <= 4) return AppStrings.veryGood.tr();
    return AppStrings.excellent.tr();
  }

  Color _getRatingColor() {
    if (_rating <= 1) return ColorManager.error;
    if (_rating <= 2) return Colors.orange;
    if (_rating <= 3) return Colors.yellow;
    if (_rating <= 4) return Colors.lightGreen;
    return ColorManager.teal;
  }

  void _submitRating() {
    final comment = _commentController.text;
    // Handle rating and comment submission logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModernRatingDialog(
          rating: _rating,
          comment: comment,
        );
      },
    );

  }
}
class ModernRatingDialog extends StatelessWidget {
  final double rating;
  final String comment;

  const ModernRatingDialog({
    super.key,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: 20.w,
            top: 65.h + 20.h,
            right: 20.w,
            bottom: 20.h,
          ),
          margin: EdgeInsets.only(top: 45.h),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),

          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppStrings.thankYou.tr(),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  AppStrings.weAppreciateYourFeedback.tr(),
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 22.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 24.sp),
                    SizedBox(width: 5.w),
                    Text(
                      '${AppStrings.yourRating.tr() }: $rating',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Text(
                  '${AppStrings.yourComment.tr()} :',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    comment.isEmpty ? AppStrings.noComment.tr() : comment,
                    style: TextStyle(fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 22.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppStrings.close.tr(),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 45.r,
            child: Icon(
              Icons.thumb_up,
              color: Colors.white,
              size: 50.r,
            ),
          ),
        ),
      ],
    );
  }
}