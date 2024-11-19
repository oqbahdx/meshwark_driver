import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'carrier_map_state.dart';

class CarrierMapCubit extends Cubit<CarrierMapState> {
  CarrierMapCubit() : super(CarrierMapInitial());
  bool isMoveFurnitureActive = false;
  bool isStart = false;
  startMoveFurniture() {
    isMoveFurnitureActive = true;
    emit(StartMoveFurnitureState());
  }

  endMoveFurniture() {
    isMoveFurnitureActive = false;
    emit(EndMoveFurnitureState());
  }
}
