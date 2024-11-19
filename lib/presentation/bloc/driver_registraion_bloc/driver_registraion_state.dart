part of 'driver_registraion_cubit.dart';

@immutable
abstract class DriverRegistraionState {}

class DriverRegistraionInitial extends DriverRegistraionState {}
class UpdatePersonalImageSuccessState extends DriverRegistraionState {}
class RestImageSuccessState extends DriverRegistraionState {}
class UpdatePlateImageSuccessState extends DriverRegistraionState {}
class UpdateLicenseImageSuccessState extends DriverRegistraionState {}
class UpdateInsuranceImageImageSuccessState extends DriverRegistraionState {}
class UpdateServiceState extends DriverRegistraionState {}
class WomanIsActiveState extends DriverRegistraionState {}
class ChangeIsAgreedState extends DriverRegistraionState {}
class AddProfileSuccessState extends DriverRegistraionState {}
class AddProfileLoadingState extends DriverRegistraionState {}
class AddProfileErrorState extends DriverRegistraionState {
  final String error;

  AddProfileErrorState(this.error);
}
