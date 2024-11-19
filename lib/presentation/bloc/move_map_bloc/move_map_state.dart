part of 'move_map_cubit.dart';

@immutable
abstract class MoveMapState {}

class MoveMapInitial extends MoveMapState {}
class StartMoveFurnitureState extends MoveMapState {}
class EndMoveFurnitureState extends MoveMapState {}
class EndCityToCityTripLoadingState extends MoveMapState {}
class EndCityToCityTripSuccessState extends MoveMapState {}
class EndCityToCityTripErrorState extends MoveMapState {
  final String error;

  EndCityToCityTripErrorState(this.error);
}

class StartCityToCityTripLoadingState extends MoveMapState{}
class StartCityToCityTripSuccessState extends MoveMapState{}
class StartCityToCityTripErrorState extends MoveMapState{
  final String error;

  StartCityToCityTripErrorState(this.error);
}