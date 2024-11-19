import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:meshwark_driver/app/app_prefs.dart';
import 'package:meshwark_driver/app/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meshwark_driver/presentation/bloc/BlocObserver.dart';
import 'package:meshwark_driver/presentation/resources/language_manager.dart';
import 'app/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/di.dart';
import 'data/network/dio_helper.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// todo : make sure driver has a role = 'driver' in login page
String? fcmToken;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  fcmToken = await messaging.getToken();
  print("fcm token: $fcmToken");
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await initAppModule();
  AppPreferences appPreferences = instance<AppPreferences>();
  appPreferences.getUserId(key: 'userId').then((value) {
    Constants.id = value ?? "";
  });

  appPreferences.getIsBoarding(key: 'boarding').then((value) {
    Constants.isBoarding = value ?? 0;
  });
  appPreferences.getFirstName(key: 'firstName').then((value) {
    Constants.firstName = value ?? "";
  });

  appPreferences.getFirstName(key: 'lastName').then((value) {
    Constants.lastName = value ?? "";
  });
  runApp(ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) {
      return EasyLocalization(
          supportedLocales: const [ARABIC_LOCALE, ENGLISH_LOCALE],
          path: ASSET_PATH_LOCALE,
          child: Phoenix(child: MyApp()));
    },
  ));
}
