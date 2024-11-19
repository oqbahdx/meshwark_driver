import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/language_manager.dart';

const String prefsKeyLang = "prefsKeyLang";
const String prefsKeyOnBoarding = "prefsKeyMainRegister";
const String prefsKeyIsLoggedIn = "prefsKeyIsLoggedIn";
const String prefsKeyIsProfileComplete = "prefsKeyIsProfileComplete";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLang);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ARABIC.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.ARABIC.getValue()) {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.ENGLISH.getValue());
    } else {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.ARABIC.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCALE;
    } else {
      return ENGLISH_LOCALE;
    }
  }

  // on boarding

  Future<void> setMainRegisterScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoarding, true);
  }

  Future<bool> isMainRegisterScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoarding) ?? false;
  }

  //login

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsLoggedIn) ?? false;
  }

  // register and profile
  Future<void> setUserProfileComplete() async {
    _sharedPreferences.setBool(prefsKeyIsProfileComplete, true);
  }

  Future<bool> isUserProfileComplete() async {
    return _sharedPreferences.getBool(prefsKeyIsProfileComplete) ?? false;
  }

  Future<void> deleteUserLogin() async {
    _sharedPreferences.setBool(prefsKeyIsLoggedIn, false);
  }

  Future<String?> getUserId({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setUserId({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<int?> getCarSeats({required String key}) async {
    return _sharedPreferences.getInt(key);
  }

  Future<void> setCarSeats({
    required var key,
    required int value,
  }) async {
    _sharedPreferences.setInt(key, value);
  }

  Future<int?> getIsBoarding({required String key}) async {
    return _sharedPreferences.getInt(key);
  }

  Future<void> setIsBoarding({
    required var key,
    required int value,
  }) async {
    _sharedPreferences.setInt(key, value);
  }

  Future<String?> getFirstName({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setFirstName({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getMiddleName({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setMiddleName({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getLastName({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setLastName({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getToken({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setToken({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<void> resetPreferences() async {
    setFirstName(key: "firstName", value: "");
    setFirstName(key: "lastName", value: "");
    setUserId(key: "userId", value: "");
    setToken(key: "token", value: "");
    setCarSeats(key: "key", value: 0);
  }
}
