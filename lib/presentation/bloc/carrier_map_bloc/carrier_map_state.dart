part of 'carrier_map_cubit.dart';

@immutable
abstract class CarrierMapState {}

class CarrierMapInitial extends CarrierMapState {}
class StartMoveFurnitureState extends CarrierMapState {}
class EndMoveFurnitureState extends CarrierMapState {}
