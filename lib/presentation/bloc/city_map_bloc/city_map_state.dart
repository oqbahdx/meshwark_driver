part of 'city_map_cubit.dart';

@immutable
abstract class CityMapState {}

class CityMapInitial extends CityMapState {}

class StartTripState extends CityMapState {}

class CancelTripState extends CityMapState {}

class EndCityToCityTripLoadingState extends CityMapState {}

class EndCityToCityTripSuccessState extends CityMapState {}

class EndCityToCityTripErrorState extends CityMapState {
  final String error;
  EndCityToCityTripErrorState(this.error);
}

class ChangeStartCityState extends CityMapState {}

class ChangeEndCityState extends CityMapState {}

class StartCityToCityTripLoadingState extends CityMapState {}

class StartCityToCityTripSuccessState extends CityMapState {}

class StartCityToCityTripErrorState extends CityMapState {
  final String error;

  StartCityToCityTripErrorState(this.error);
}

class AddTripHistoryLoadingState extends CityMapState {}

class AddTripHistorySuccessState extends CityMapState {}

class AddTripHistoryErrorState extends CityMapState {
  final String error;

  AddTripHistoryErrorState(this.error);
}

class DriverUpdateReceivedState extends CityMapState {
  final UserModel userModel;

  DriverUpdateReceivedState(this.userModel);
}

class RideRequestReceivedState extends CityMapState {
  final String riderId;
  final Map<String, dynamic> request;

  RideRequestReceivedState(this.riderId, this.request);
}

class DriverResponseReceivedState extends CityMapState {
  final bool accepted;

  DriverResponseReceivedState(this.accepted);
}


class CancelTripLoadingState extends CityMapState {}

class CancelTripSuccessState extends CityMapState {}

class CancelTripErrorState extends CityMapState {
  final String error;

  CancelTripErrorState(this.error);
}

class AddPassengerState extends CityMapState {}