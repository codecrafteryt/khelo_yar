
/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Splash screen.dart
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/extensions/extentions.dart';
import '../../utils/values/my_color.dart';
import 'auth/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Get.off(() => const LoginScreen());
    });
  }

  // // Method to check login status and navigate accordingly
  // void _checkLoginStatus() {
  //   final auth = FirebaseAuth.instance;
  //   final user = auth.currentUser;
  //
  //   if (user != null) {
  //     Timer(const Duration(seconds: 5), () => Get.off(() => const HomePages()),
  //     );
  //   } else {
  //     Timer(const Duration(seconds: 5), () => Get.off(() => OnboardingScreen()),
  //     );
  //   }
  // }

  // statusCheck() {
  //   Timer(const Duration(seconds: 2), () async {
  //     if (
  //     Get.find<AuthController>().sharedPreferences.getBool("firstTimeWalkThrough") ?? true) {
  //       Get.find<AuthController>().sharedPreferences.setBool("firstTimeWalkThrough", false);
  //       Get.offAll(() => OnboardingScreen());
  //     } else {
  //       if (Get.find<AuthController>().sharedPreferences.getString(
  //           Constants.refreshToken) == null || Get.find<AuthController>().sharedPreferences.getString(Constants.refreshToken) == "")
  //       {
  //         Get.offAll(() => const LoginScreen());
  //       } else {
  //         print("my refresh token${Get.find<AuthController>().sharedPreferences.getString(Constants.refreshToken)}");
  //         Get.find<AuthController>().checkSession1();
  //
  //       }
  //     }
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0.w),
                  child: Image.asset(
                    'assets/images/kheloyaarlogo.png',
                    width: 600.w,
                  ),
                ),
                20.sbh,
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Text(
              "Version: 1.0.2",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

