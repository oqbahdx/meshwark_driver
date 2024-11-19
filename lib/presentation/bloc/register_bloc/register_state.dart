part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class MakePasswordVisibleState extends RegisterState {}
class RegisterLoadingState extends RegisterState {}
class RegisterSuccessState extends RegisterState {}
class RegisterErrorState extends RegisterState {
  final String error;
  RegisterErrorState(this.error);
}
class OtpLoadingState extends RegisterState{}
class OtpSuccessState extends RegisterState{}