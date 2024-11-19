import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/notification_bloc/notification_cubit.dart';
import '../resources/strings_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  Future<void> _onRefresh(BuildContext context) async {
    context.read<NotificationCubit>().getNotification();
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fToast.init(context);
    context.read<NotificationCubit>().getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: Text(
          AppStrings.notifications.tr(),
          style: getBoldStyle(
            color: ColorManager.primary,
            fontSize: FontSize.s20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            if (state is DeleteNotificationSuccessState) {
              context.read<NotificationCubit>().getNotificationAfterDeleteItem();
            }
          },
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primary),
                  ));
            }
            final cubit = context.read<NotificationCubit>();
            final notifications = cubit.notificationList;

            if (notifications?.isEmpty ?? true) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 80, color: ColorManager.lightGrey),
                    SizedBox(height: 16.h),
                    Text(
                      AppStrings.noNotificationMessage.tr(),
                      style: getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s18.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: notifications!.length,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.id ?? UniqueKey().toString()),
                  background: _buildDismissibleBackground(),
                  onDismissed: (direction) {
                    cubit.deleteNotification(id: notification.id ?? "");
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: ColorManager.lightGrey, width: 1),
                    ),
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: ColorManager.primary.withOpacity(0.1),
                        child: Icon(Icons.notifications, color: ColorManager.primary),
                      ),
                      title: Text(
                        notification.body ?? "Notification Body",
                        style: getSemiBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s16.sp,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: ColorManager.darkGrey),
                            SizedBox(width: 4.w),
                            Text(
                              "${notification.date ?? 'Date'} ${notification.time ?? 'Time'}",
                              style: getRegularStyle(
                                color: ColorManager.darkGrey,
                                fontSize: FontSize.s12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.w),
      color: Colors.red,
      child: Icon(Icons.delete, color: ColorManager.error),
    );
  }
}