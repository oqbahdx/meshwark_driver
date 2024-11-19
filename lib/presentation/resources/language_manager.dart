import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, ARABIC }

const String ARABIC = "ar";
const String ENGLISH = "en";
const Locale ARABIC_LOCALE = Locale("ar","SA");
const Locale ENGLISH_LOCALE = Locale("en","US");
const String ASSET_PATH_LOCALE = "assets/translation";
extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
    }
  }
}
