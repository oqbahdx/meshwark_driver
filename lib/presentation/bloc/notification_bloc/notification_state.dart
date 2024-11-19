part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationSuccessState extends NotificationState {}

class NotificationErrorState extends NotificationState {
  final String error;

  NotificationErrorState(this.error);
}

class DeleteNotificationLoadingState extends NotificationState {}
class DeleteNotificationSuccessState extends NotificationState {}
class DeleteNotificationErrorState extends NotificationState {
  final String error;
  DeleteNotificationErrorState(this.error);
}