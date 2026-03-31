/*
 ---------------------------------------
 Project: Khelo Yar Mobile Application
 Date: March 30, 2026
 Author: Ameer Salman
 ---------------------------------------
 Description: Auth Logic.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../GetServices/CheckConnectionService.dart';
import '../data/auth_repo/auth_repo.dart';
import '../views/screen/auth/forgot_password/forgot_password_otp_screen.dart';
import '../views/screen/auth/forgot_password/forgot_password_re_enter_password_screen.dart';
import '../views/screen/auth/forgot_password/forgot_password_screen.dart';
import '../views/screen/auth/login/login_screen.dart';
import '../views/screen/auth/sign_up/sign_up_screen.dart';
import '../views/screen/home/bottom_nav_bar.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;

  AuthController({
    required this.authRepo,
    required this.sharedPreferences,
  });

  final CheckConnectionService connectionService = CheckConnectionService();

  static const int otpLength = 6;

  /////// LOGIN SCREEN ///////
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final RxBool loginObscurePassword = true.obs;

  void toggleLoginPasswordVisibility() {
    loginObscurePassword.value = !loginObscurePassword.value;
  }

  String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    if (!v.contains('@')) return 'Enter a valid email';
    return null;
  }

  String? validateLoginPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Please enter your password';
    return null;
  }

  void onLoginContinue() {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    // TODO: call login API.
  }

  void navigateToForgotPassword() {
    Get.to(() => const ForgotPasswordScreen());
  }

  void navigateToSignUp() {
    Get.to(() => const SignUpScreen());
  }

  ////// END LOGIN ///////

  /////// SIGN UP SCREEN ///////
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final TextEditingController signUpNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController = TextEditingController();
  final RxBool signUpObscurePassword = true.obs;

  void toggleSignUpPasswordVisibility() {
    signUpObscurePassword.value = !signUpObscurePassword.value;
  }

  String? validateName(String? value) {
    if ((value?.trim() ?? '').isEmpty) return 'Please enter your name';
    return null;
  }

  String? validateSignUpPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please enter a password';
    if (v.length < 6) return 'Use at least 6 characters';
    return null;
  }

  void onCreateAccount() {
    if (!(signUpFormKey.currentState?.validate() ?? false)) return;
    // TODO: call sign up API.
  }

  void navigateToLoginReplace() {
    Get.off(() => const LoginScreen());
  }

  ////// END SIGNUP ///////

  /////// FORGOT PASSWORD ///////
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController forgotEmailController = TextEditingController();

  void onForgotPasswordContinue() {
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) return;
    Get.to(() => ForgotPasswordOtpScreen());
  }

  ////// END FORGOT PASSWORD ///////

  /////// OTP VERIFICATION ///////
  final TextEditingController otpController = TextEditingController();
  final RxInt otpResendTimer = 30.obs;
  final RxBool showOtpError = false.obs;
  Timer? _otpTimer;

  bool get isOtpComplete => otpController.text.trim().length == otpLength;

  void startOtpTimer() {
    otpResendTimer.value = 30;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpResendTimer.value > 0) {
        otpResendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void onOtpChanged(String value) {
    if (showOtpError.value && value.length == otpLength) {
      showOtpError.value = false;
    }
  }

  void onResendOtp() {
    if (otpResendTimer.value > 0) return;
    showOtpError.value = false;
    startOtpTimer();
    // TODO: call resend OTP API.
  }

  void closeOtpError() {
    showOtpError.value = false;
  }

  void onOtpContinue() {
    if (!isOtpComplete) {
      showOtpError.value = true;
      return;
    }
    showOtpError.value = false;
    Get.to(() => const ForgotPasswordReEnterPasswordScreen());
  }

  ////// END OTP ///////

  /////// RESET PASSWORD ///////
  final TextEditingController resetNewPasswordController = TextEditingController();
  final TextEditingController resetRepeatPasswordController = TextEditingController();
  final RxBool resetObscureNewPassword = true.obs;
  final RxBool resetObscureRepeatPassword = true.obs;
  final RxBool resetSubmitted = false.obs;

  void toggleResetNewPasswordVisibility() {
    resetObscureNewPassword.value = !resetObscureNewPassword.value;
  }

  void toggleResetRepeatPasswordVisibility() {
    resetObscureRepeatPassword.value = !resetObscureRepeatPassword.value;
  }

  bool get hasMinLength {
    final len = resetNewPasswordController.text.length;
    return len >= 8 && len <= 16;
  }

  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(resetNewPasswordController.text);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(resetNewPasswordController.text);
  bool get hasSpecialCharacter =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(resetNewPasswordController.text);
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(resetNewPasswordController.text);

  bool get passwordRulesValid =>
      hasMinLength && hasUppercase && hasLowercase && hasSpecialCharacter && hasNumber;

  bool get passwordsMatch =>
      resetRepeatPasswordController.text.isNotEmpty &&
      resetNewPasswordController.text == resetRepeatPasswordController.text;

  bool get showNewPasswordError {
    if (resetNewPasswordController.text.isEmpty) return false;
    return !passwordRulesValid;
  }

  bool get showRepeatPasswordError {
    if (resetRepeatPasswordController.text.isEmpty) return false;
    return !passwordsMatch;
  }

  bool get showMismatchError =>
      resetRepeatPasswordController.text.isNotEmpty &&
      !passwordsMatch &&
      (resetSubmitted.value || showRepeatPasswordError);

  bool get canSubmitResetPassword => passwordRulesValid && passwordsMatch;

  void onResetPasswordInputChanged() {
    update();
  }

  void onUpdatePasswordPressed() {
    resetSubmitted.value = true;
    if (!canSubmitResetPassword) return;
    // TODO: call reset password API.
  }

  ////// END RESET PASSWORD ///////

  /////// COMMON NAVIGATION ///////
  void goBack() {
    Get.back();
  }

  void onGoogleAuthPressed() {
    Get.to(() => NavBar());
  }
  ////// END COMMON NAVIGATION ///////

  @override
  void onInit() {
    super.onInit();
    startOtpTimer();
    otpController.addListener(update);
    resetNewPasswordController.addListener(update);
    resetRepeatPasswordController.addListener(update);
  }

  @override
  void onClose() {
    _otpTimer?.cancel();

    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    forgotEmailController.dispose();
    otpController.dispose();
    resetNewPasswordController.dispose();
    resetRepeatPasswordController.dispose();

    super.onClose();
  }

}
