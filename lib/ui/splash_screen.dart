import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/resources/app_colors.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';
import 'package:zithara_excersize/services/apiservices.dart';
import 'package:zithara_excersize/services/router.dart';
import 'package:zithara_excersize/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UiHelper uihelper = UiHelper();
  AppColors appClrs = AppColors();
  Apiservices apiservices = Get.find<Apiservices>();
  @override
  void initState() {
    super.initState();

    Future.delayed((const Duration(seconds: 1)), () async {
      String status = await apiservices.getString("islogin");
      // if (status == "true") {
      //   Get.offNamedUntil(RoutePaths.home, (e) => false);
      // } else {
      Get.to(() => const LoginScreen());
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        alignment: Alignment.center,
        height: 150,
        width: 150,
        decoration: UiHelper.roundedBorderWithColor(14, appClrs.primaryclr),
        child: Text(
          "Z",
          style: TextStyle(fontWeight: FontWeight.w900, color: appClrs.whiteclr, fontSize: 100),
        ),
      ),
    ));
  }
}
