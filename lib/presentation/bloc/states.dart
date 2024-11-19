abstract class AppStates {}

class InitialAppState extends AppStates {}

class UpdatePersonalImageSuccessState extends AppStates {}
class UpdateIdImageSuccessState extends AppStates {}
class UpdatePlateImageSuccessState extends AppStates {}
class UpdateLicenseImageSuccessState extends AppStates {}
class UpdateInsuranceImageImageSuccessState extends AppStates {}

class LoadingImageSuccessState extends AppStates {}

class RestImageSuccessState extends AppStates {}

class UpdateVehicleSuccessState extends AppStates {}

class UpdateImageProfileSuccessState extends AppStates {}



class OtpSuccessState extends AppStates {}

class OtpErrorState extends AppStates {
  final String error;

  OtpErrorState(this.error);
}



class ChangeIsAgreedState extends AppStates {}

class ChangeYearOfCarState extends AppStates {}

class ChangeModelOfCarState extends AppStates {}

class ChangeColorOfCarState extends AppStates {}

class ChangeRidersOfCarState extends AppStates {}

class MainIsActiveState extends AppStates {}

class WomanIsActiveState extends AppStates {}

class ChangeCityState extends AppStates {}

class StartTripState extends AppStates {}

class CancelTripState extends AppStates {}

class GetCurrentDriverLoadingState extends AppStates {}

class GetCurrentDriverSuccessState extends AppStates {}

class GetCurrentDriverErrorState extends AppStates {
  final String error;

  GetCurrentDriverErrorState(this.error);
}






class SetCarTrueState extends AppStates {}

class SetVanTrueState extends AppStates {}

class SetTruckTrueState extends AppStates {}

class StartMoveFurnitureState extends AppStates{}
class EndMoveFurnitureState extends AppStates{}

class UpdateServiceState extends AppStates{}





class ChangeEndCityState extends AppStates{}
class ChangeStartCityState extends AppStates{}





class StartCityToCityTripLoadingState extends AppStates{}
class StartCityToCityTripSuccessState extends AppStates{}
class StartCityToCityTripErrorState extends AppStates{
  final String error;

  StartCityToCityTripErrorState(this.error);
}

class EndCityToCityTripLoadingState extends AppStates{}
class EndCityToCityTripSuccessState extends AppStates{}
class EndCityToCityTripErrorState extends AppStates{
  final String error;

  EndCityToCityTripErrorState(this.error);
}

class StartMoveFurnitureTripLoadingState extends AppStates{}
class StartMoveFurnitureTripSuccessState extends AppStates{}
class StartMoveFurnitureTripErrorState extends AppStates{
  final String error;

  StartMoveFurnitureTripErrorState(this.error);
}

class EndStartMoveFurnitureTripLoadingState extends AppStates{}
class EndStartMoveFurnitureTripSuccessState extends AppStates{}
class EndStartMoveFurnitureTripErrorState   extends AppStates{
  final String error;
  EndStartMoveFurnitureTripErrorState(this.error);

}
