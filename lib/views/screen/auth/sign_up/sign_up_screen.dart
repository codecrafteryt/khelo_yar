/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Sign up — UI only; Google action at bottom.
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
import '../../../widgets/custom_leading_icon.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/google_auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                    key: authController.signUpFormKey,
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
                          labelText: 'Full name',
                          hintText: 'Muhammad Ali',
                          controller: authController.signUpNameController,
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
                          validator: authController.validateName,
                        ),
                        17.sbh,
                        CustomTextField(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          controller: authController.signUpEmailController,
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
                        17.sbh,
                        Obx(
                          () => CustomTextField(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Password',
                            hintText: 'Create a password',
                            controller: authController.signUpPasswordController,
                            isObscureText: authController.signUpObscurePassword.value,
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
                              onPressed: authController.toggleSignUpPasswordVisibility,
                              icon: Icon(
                                authController.signUpObscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.black.withOpacity(0.6),
                                size: 20.sp,
                              ),
                            ),
                            validator: authController.validateSignUpPassword,
                          ),
                        ),
                        20.sbh,
                        CustomButton(
                          text: 'Create account',
                          onPressed: authController.onCreateAccount,
                          width: double.infinity,
                          height: 52.h,
                          borderRadius: 12.r,
                          backgroundColor: MyColors.brandPrimary,
                          borderColor: MyColors.brandPrimary,
                          textColor: MyColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        // 16.sbh,
                        // Wrap(
                        //   alignment: WrapAlignment.center,
                        //   crossAxisAlignment: WrapCrossAlignment.center,
                        //   spacing: 0,
                        //   runSpacing: 4.h,
                        //   children: [
                        //     Text(
                        //       'By signing up, you agree to our ',
                        //       style: TextStyle(
                        //         fontFamily: MyFonts.plusJakartaSans,
                        //         fontSize: 12.sp,
                        //         color: MyColors.textSecondary,
                        //         height: 1.45,
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {},
                        //       child: Text(
                        //         'Terms',
                        //         style: TextStyle(
                        //           fontFamily: MyFonts.plusJakartaSans,
                        //           fontSize: 12.sp,
                        //           decoration: TextDecoration.underline,
                        //           color: MyColors.blackDark,
                        //           fontWeight: FontWeight.w600,
                        //           height: 1.45,
                        //         ),
                        //       ),
                        //     ),
                        //     Text(
                        //       ' and ',
                        //       style: TextStyle(
                        //         fontFamily: MyFonts.plusJakartaSans,
                        //         fontSize: 12.sp,
                        //         color: MyColors.textSecondary,
                        //         height: 1.45,
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {},
                        //       child: Text(
                        //         'Privacy Policy',
                        //         style: TextStyle(
                        //           fontFamily: MyFonts.plusJakartaSans,
                        //           fontSize: 12.sp,
                        //           decoration: TextDecoration.underline,
                        //           color: MyColors.blackDark,
                        //           fontWeight: FontWeight.w600,
                        //           height: 1.45,
                        //         ),
                        //       ),
                        //     ),
                        //     Text(
                        //       '.',
                        //       style: TextStyle(
                        //         fontFamily: MyFonts.plusJakartaSans,
                        //         fontSize: 12.sp,
                        //         color: MyColors.textSecondary,
                        //         height: 1.45,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        20.sbh,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 14.sp,
                                color: MyColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: authController.navigateToLoginReplace,
                              child: Text(
                                'Log in',
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
