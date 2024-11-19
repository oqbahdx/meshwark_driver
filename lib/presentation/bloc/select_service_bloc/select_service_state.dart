part of 'select_service_cubit.dart';

@immutable
abstract class SelectServiceState {}

class SelectServiceInitial extends SelectServiceState {}
class GetCurrentDriverLoadingState extends SelectServiceState {}
class GetCurrentDriverSuccessState extends SelectServiceState {}
class GetCurrentDriverErrorState extends SelectServiceState {
  final String error;
  GetCurrentDriverErrorState(this.error);
}

class SetCarTrueState extends SelectServiceState{}
class SetVanTrueState extends SelectServiceState{}
class SetTruckTrueState extends SelectServiceState{}