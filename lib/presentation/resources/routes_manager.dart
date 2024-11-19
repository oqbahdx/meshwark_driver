import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:meshwark_driver/presentation/customer_support/cutomer_support_view.dart';
import 'package:meshwark_driver/presentation/driver_information_registration/driver_information_registration_view.dart';
import 'package:meshwark_driver/presentation/get_started/get_strated_view.dart';
import 'package:meshwark_driver/presentation/main_register/main_register_view.dart';
import 'package:meshwark_driver/presentation/notification/notification_view.dart';
import 'package:meshwark_driver/presentation/otp/otp_view.dart';
import 'package:meshwark_driver/presentation/register/register_view.dart';
import 'package:meshwark_driver/presentation/select_service/select_service.dart';
import 'package:meshwark_driver/presentation/trip_history/trip_history_view.dart';
import '../about_app/about_app_view.dart';

import '../forgot_password/forgot_password_view.dart';
import '../login/login_view.dart';
import '../map/car_carrier_map_view.dart';
import '../map/city_to_city_map_view.dart';
import '../map/move_furniture_map_view.dart';
import '../profile/profile_view.dart';
import '../review_account/review_account_view.dart';

import '../wallet/wallet_view.dart';
import 'Strings_manager.dart';

class Routes {
  static const String splashRoute = "/";
  static const String getStartedRoute = "/getStarted";
  static const String mainRegisterRoute = "/mainRegister";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String otpRoute = "/otp";
  static const String cityToCityMapRoute = "/cityToCityMap";
  static const String driverProfileRoute = "/driverInformation";
  static const String notificationRoute = "/notification";
  static const String tripHistoryRoute = "/tripHistory";
  static const String balanceRoute = "/balance";
  static const String customerSupportRoute = "/customerSupport";
  static const String driverInformationRegistrationRoute =
      "/driverInformationRegistration";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String aboutAppRoute = "/aboutApp";
  static const String reviewAccountRoute = "/reviewAccount";
  static const String selectServiceViewRoute = "/selectServiceView";
  static const String moveFurnitureMapViewRoute = "/moveFurnitureMapView";
  static const String notificationTestRoute = "/notificationTest";
  static const String carCarrierMapRoute = "/carCarrierMap";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.getStartedRoute:
        return _getPageRoute(const GetStartedView());
      case Routes.mainRegisterRoute:
        return _getPageRoute(MainRegisterView());
      case Routes.loginRoute:
        return _getPageRoute(const LoginView());
      case Routes.registerRoute:
        return _getPageRoute(const RegisterView());
      case Routes.otpRoute:
        return _getPageRoute(const OTPView(number: ''));
      case Routes.cityToCityMapRoute:
        return _getPageRoute(const CityToCityMapView());
      case Routes.driverProfileRoute:
        return _getPageRoute(const ProfileView());
      case Routes.notificationRoute:
        return _getPageRoute(const NotificationView());
      case Routes.tripHistoryRoute:
        return _getPageRoute(const TripHistoryView());
      case Routes.balanceRoute:
        return _getPageRoute(const WalletView());
      case Routes.customerSupportRoute:
        return _getPageRoute(const CustomerSupportView());
      case Routes.driverInformationRegistrationRoute:
        return _getPageRoute(const DriverInformationRegistrationView());
      case Routes.forgotPasswordRoute:
        return _getPageRoute(const ForgotPasswordView());
      case Routes.aboutAppRoute:
        return _getPageRoute(const AboutAppView());
      case Routes.reviewAccountRoute:
        return _getPageRoute(const ReviewAccountView());
      case Routes.selectServiceViewRoute:
        return _getPageRoute(const SelectServiceView());
      case Routes.moveFurnitureMapViewRoute:
        return _getPageRoute(const MoveFurnitureMapView());
      case Routes.carCarrierMapRoute:
        return _getPageRoute(const CarCarrierMapView());
      default:
        return pageNotFound();
    }
  }

  static Route<dynamic> _getPageRoute(Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }

  static Route<dynamic> pageNotFound() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.pageNotFound.tr()),
        ),
        body: Center(child: Text(AppStrings.pageNotFound.tr())),
      ),
    );
  }
}
