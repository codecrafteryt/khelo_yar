/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Log in — UI only; Google action at bottom.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../utils/extensions/extentions.dart';
import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../../utils/values/my_images.dart';
import '../../../widgets/auth_or_divider.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_leading_icon.dart';
import '../../../widgets/google_auth_button.dart';
import '../../home/bottom_nav_bar.dart';
import '../auth_navigation.dart';
import '../forgot_password/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorder = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // UI-only: wire to Firebase / API later
    }
  }

  void _onGoogle() {
    Get.to(() => NavBar());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              // leading: CustomLeadingIcon(
              //   onPressed: (){
              //    // controller.clearSignupFields();
              //     Get.back();
              //   },
              // ),
              title: Text("Login",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: MyFonts.plusJakartaSans,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h + bottomInset),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        10.sbh,
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            MyImages.kheloYaarLogo,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        12.sbh,
                        CustomTextField(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          controller: _emailController,
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!v.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        18.sbh,
                        CustomTextField(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Password',
                          hintText: 'Password',
                          controller: _passwordController,
                          isObscureText: _obscurePassword,
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.black.withOpacity(0.6),
                              size: 20.sp,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => ForgotPasswordScreen(),);
                            },
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
                          onPressed: _onContinue,
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
                              onTap: navigateToSignUp,
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
                        GoogleAuthButton(onPressed: _onGoogle),
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
