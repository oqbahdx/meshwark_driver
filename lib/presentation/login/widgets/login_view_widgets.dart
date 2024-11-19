import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';


class BuildTextFormFiled extends StatelessWidget {
  const BuildTextFormFiled({
    super.key,
    required this.textEditingController,
    required this.labelText,
    required this.textInputType,
    this.validator,
    this.isSecure = false,
    this.icon,
    this.maxLength,
    this.maxLines = 1,
    this.padding,
  });

  final TextEditingController textEditingController;
  final String labelText;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool isSecure;
  final Widget? icon;
  final int? maxLength;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: textEditingController,
        validator: validator,
        obscureText: isSecure,
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: textInputType,
        cursorColor: ColorManager.primary,
        style: getMediumStyle(color: ColorManager.black, fontSize: FontSize.s16),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: getMediumStyle(color: Colors.grey.shade600, fontSize: FontSize.s16),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: icon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none, // Border-less for modern appearance
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: ColorManager.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: ColorManager.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: ColorManager.error),
          ),
          errorStyle: getMediumStyle(color: ColorManager.error, fontSize: FontSize.s14),
        ),
      ),
    );
  }
}

