import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshwark_driver/app/constant.dart';
import 'package:meshwark_driver/presentation/bloc/carrier_map_bloc/carrier_map_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/city_map_bloc/city_map_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/driver_registraion_bloc/driver_registraion_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/login_bloc/login_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/move_map_bloc/move_map_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/notification_bloc/notification_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/register_bloc/register_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/select_service_bloc/select_service_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/trip_history_bloc/trip_history_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/wallet_bloc/wallet_cubit.dart';

import '../presentation/cancel_trip.dart';
import '../presentation/final_trip_details/final_trip_details.dart';
import '../presentation/get_started/get_strated_view.dart';
import '../presentation/rating_view.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import '../presentation/rider_information.dart';
import '../request_order.dart';
import 'app_prefs.dart';
import 'di.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // factory
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocale().then((locale) => context.setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<RegisterCubit>(create: (context) => RegisterCubit()),
        // BlocProvider<OtpCubit>(create: (context) => OtpCubit()),
        BlocProvider<SelectServiceCubit>(
            create: (context) => SelectServiceCubit()),
        BlocProvider<CityMapCubit>(create: (context) => CityMapCubit()),
        BlocProvider<CarrierMapCubit>(create: (context) => CarrierMapCubit()),
        BlocProvider<MoveMapCubit>(create: (context) => MoveMapCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<DriverRegistrationCubit>(
            create: (context) => DriverRegistrationCubit()),
        BlocProvider<SelectServiceCubit>(
            create: (context) => SelectServiceCubit()),
        BlocProvider<NotificationCubit>(
            create: (context) => NotificationCubit()),
        BlocProvider<TripHistoryCubit>(create: (context) => TripHistoryCubit()),
        BlocProvider<WalletCubit>(create: (context) => WalletCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
      ],
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        // initialRoute: Constants.isBoarding == 0
        //     ? Routes.getStartedRoute
        //     : Constants.id == ""
        //         ? Routes.loginRoute
        //         : Routes.selectServiceViewRoute,
        home: GetStartedView(),
        theme: getApplicationTheme(),
      ),
    );
  }
}
