import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshwark_driver/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:meshwark_driver/presentation/bloc/select_service_bloc/select_service_cubit.dart';
import 'package:meshwark_driver/presentation/profile/widgets/profile_widgets.dart';
import 'package:meshwark_driver/presentation/resources/Strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meshwark_driver/presentation/select_service/select_service.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fToast.init(context);

    _firstNameController = TextEditingController(
        text: context.read<SelectServiceCubit>().userModel?.firstName);

    _lastNameController = TextEditingController(
        text: context.read<SelectServiceCubit>().userModel?.lastName);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark),
        elevation: AppSize.s0,
        backgroundColor: ColorManager.transparent,
        title: Text(
          AppStrings.profile.tr(),
          style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: isRTL() ? FontSize.s22 : FontSize.s20),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccessState) {
            context.read<ProfileCubit>().showSuccessMessage(
                message: AppStrings.updateProfileMessage.tr());
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectServiceView()));
          }
        },
        builder: (context, state) {
          var cubit = context.read<ProfileCubit>();
          if (context.read<SelectServiceCubit>().userModel == null) {
            return const DriverLoadingScreen();
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.03),
                        _buildProfilePicture(cubit),
                        SizedBox(height: height * 0.05),
                        _buildRatingAndTrips(),
                        SizedBox(height: height * 0.05),
                        BuildTextForm(
                            textInputType: TextInputType.name,
                            controller: _firstNameController!,
                            labelText: AppStrings.firstName.tr(),
                            icn: Icons.person),
                        SizedBox(height: height * 0.05),
                        BuildTextForm(
                            textInputType: TextInputType.name,
                            controller: _lastNameController!,
                            labelText: AppStrings.lastName.tr(),
                            icn: Icons.person),
                        SizedBox(height: height * 0.05),
                        _buildChangeLanguageButton(),
                        SizedBox(height: height * 0.05),
                        SizedBox(
                            height: height * 0.06,
                            width: width * 0.5,
                            child: state is UpdateProfileLoadingState
                                ? Center(
                                    child: CircularProgressIndicator.adaptive(
                                      valueColor: AlwaysStoppedAnimation(
                                          ColorManager.primary),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        if (cubit.personalImage != null) {
                                          cubit.updateProfileWithImage(
                                            firstName: _firstNameController!
                                                .text
                                                .trim(),
                                            lastName: _lastNameController!.text
                                                .trim(),
                                          );
                                        } else {
                                          cubit.updateProfile(
                                            firstName: _firstNameController!
                                                .text
                                                .trim(),
                                            lastName: _lastNameController!.text
                                                .trim(),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      AppStrings.update.tr(),
                                      style: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: isRTL()
                                            ? FontSize.s18.sp
                                            : FontSize.s16.sp,
                                      ),
                                    ),
                                  ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfilePicture(ProfileCubit cubit) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        cubit.getAlertDialog(
            onTapCam: () {
              cubit.getPersonalImage(ImageSource.camera).then((value) {
                Navigator.of(context).pop();
              });
            },
            onTapGal: () {
              cubit.getPersonalImage(ImageSource.gallery).then((value) {
                Navigator.of(context).pop();
              });
            },
            context: context);
      },
      child: cubit.personalImage == null
          ? Card(
              elevation: AppSize.s4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s20)),
              child: Container(
                height: MediaQuery.sizeOf(context).width * 0.3,
                width: MediaQuery.sizeOf(context).width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s20),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${context.read<SelectServiceCubit>().userModel?.personalImage}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Image.asset(ImageAssets.appLogo),
                    errorWidget: (context, url, error) =>
                        Image.asset(ImageAssets.appLogo),
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                Card(
                  elevation: AppSize.s4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s20)),
                  child: Container(
                    height: MediaQuery.sizeOf(context).width * 0.3,
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s20),
                      child: Image.file(
                        cubit.personalImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () {
                        cubit.deletePersonalImage();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: ColorManager.error,
                      )),
                ),
              ],
            ),
    );
  }

  Widget _buildRatingAndTrips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              "${context.read<SelectServiceCubit>().userModel?.rating}",
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s20.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.rating.tr(),
              style: getRegularStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s14.sp,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(Icons.commute, color: ColorManager.primary, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              "${context.read<SelectServiceCubit>().userModel?.canceledTrips ?? 0}",
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s20.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.totalTrips.tr(),
              style: getRegularStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChangeLanguageButton() {
    return TextButton(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateColor.resolveWith((states) => ColorManager.primary),
      ),
      onPressed: () {
        _appPreferences.changeAppLanguage();
        Phoenix.rebirth(context);
      },
      child: Text(
        AppStrings.changeLanguage.tr(),
        style: getBoldStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s16.sp,
        ),
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  @override
  void dispose() {
    _firstNameController!.dispose();
    _lastNameController!.dispose();
    super.dispose();
  }
}
