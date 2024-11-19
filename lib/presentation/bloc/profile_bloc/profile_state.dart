part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class UpdatePersonalImageSuccessState extends ProfileState {}
class UpdateProfileLoadingState extends ProfileState {}
class UpdateProfileSuccessState extends ProfileState {}
class UpdateProfileErrorState extends ProfileState {
  final String error;

  UpdateProfileErrorState(this.error);
}

class DeletePersonalImage extends ProfileState{}