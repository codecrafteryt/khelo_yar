/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Avoids circular imports between login / sign-up screens.
*/

import 'package:get/get.dart';
import 'login/login_screen.dart';
import 'sign_up/sign_up_screen.dart';

void navigateToSignUp() {
  Get.to(() => const SignUpScreen());
}

void navigateToLoginReplace() {
  Get.off(() => const LoginScreen());
}
