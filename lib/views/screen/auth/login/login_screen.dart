/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Log in — UI only; Google action at bottom.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../utils/extensions/extentions.dart';
import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../../utils/values/my_images.dart';
import '../../../widgets/auth_or_divider.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/google_auth_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorder = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h + bottomInset),
                child: Form(
                    key: authController.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        60.sbh,
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            MyImages.kheloYaarLogo,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        100.sbh,
                        CustomTextField(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          controller: authController.loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          borderRadius: 12.r,
                          padding: EdgeInsets.zero,
                          borderColor: _defaultBorder,
                          focusedBorderColor: Colors.black,
                          enabledBorderWidth: 0.5,
                          focusedBorderWidth: 1,
                          errorBorderColor: _errorColor,
                          errorBorderWidth: 1,
                          focusedErrorBorderWidth: 1,
                          hintColor: _hintColor,
                          textColor: Colors.black,
                          cursorColor: Colors.black,
                          fillColor: Colors.transparent,
                          focusedFillColor: Colors.transparent,
                          fontSize: 14.sp,
                          hintFontWeight: FontWeight.w400,
                          labelColor: Colors.black,
                          floatingLabelStyle: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                          validator: authController.validateEmail,
                        ),
                        18.sbh,
                        Obx(() => CustomTextField(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Password',
                            hintText: 'Password',
                            controller: authController.loginPasswordController,
                            isObscureText: authController.loginObscurePassword.value,
                            borderRadius: 12.r,
                            padding: EdgeInsets.zero,
                            borderColor: _defaultBorder,
                            focusedBorderColor: Colors.black,
                            enabledBorderWidth: 0.5,
                            focusedBorderWidth: 1,
                            errorBorderColor: _errorColor,
                            errorBorderWidth: 1,
                            focusedErrorBorderWidth: 1,
                            hintColor: _hintColor,
                            textColor: Colors.black,
                            cursorColor: Colors.black,
                            fillColor: Colors.transparent,
                            focusedFillColor: Colors.transparent,
                            fontSize: 14.sp,
                            hintFontWeight: FontWeight.w400,
                            labelColor: Colors.black,
                            floatingLabelStyle: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              onPressed: authController.toggleLoginPasswordVisibility,
                              icon: Icon(
                                authController.loginObscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.black.withOpacity(0.6),
                                size: 20.sp,
                              ),
                            ),
                            validator: authController.validateLoginPassword,
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: authController.navigateToForgotPassword,
                            style: TextButton.styleFrom(
                              foregroundColor: MyColors.brandPrimary,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              textStyle: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        8.sbh,
                        CustomButton(
                          text: 'Continue',
                          onPressed: authController.onLoginContinue,
                          width: double.infinity,
                          borderRadius: 12.r,
                          backgroundColor: MyColors.brandPrimary,
                          borderColor: MyColors.brandPrimary,
                          textColor: MyColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        20.sbh,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to KheloYaar? ',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: MyColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: authController.navigateToSignUp,
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.blackDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        24.sbh,
                        const AuthOrDivider(),
                        20.sbh,
                        GoogleAuthButton(onPressed: authController.onGoogleAuthPressed),
                      ],
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
