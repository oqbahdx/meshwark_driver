import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meshwark_driver/presentation/resources/color_manager.dart';
import 'package:meshwark_driver/presentation/resources/fonts_manager.dart';
import 'package:meshwark_driver/presentation/resources/style_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMessageToApp {
 static launchWhatsapp(BuildContext context) async {
    var whatsapp = "+249929990093";
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello oqbah from  meshwark app";
    var whatsappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.parse("hello oqbah form  meshwark app")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatsappURLIos)) {
        await launch(whatsappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "whatsapp is not installed",
            style: getSemiBoldStyle(
                color: ColorManager.white, fontSize: FontSize.s16),
          ),
          backgroundColor: ColorManager.darkPrimary,
        ));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "whatsapp is not installed",
            style: getSemiBoldStyle(
                color: ColorManager.white, fontSize: FontSize.s16),
          ),
          backgroundColor: ColorManager.darkPrimary,
        ));
      }
    }
  }

 static Future<void> launchEmail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openUrl({required String url}) {
    launch(url, forceWebView: false, enableJavaScript: true);
  }
}
