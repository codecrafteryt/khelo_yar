/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Sign up — UI only; Google action at bottom.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import '../../home/bottom_nav_bar.dart';
import '../auth_navigation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorder = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      // UI-only
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
              leading: CustomLeadingIcon(
                onPressed: (){
                  // controller.clearSignupFields();
                  Get.back();
                },
              ),
              title: Text("Signup",
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
                        17  .sbh,
                        CustomTextField(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Full name',
                          hintText: 'Muhammad Ali',
                          controller: _nameController,
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
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        17.sbh,
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
                        17.sbh,
                        CustomTextField(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Password',
                          hintText: 'Create a password',
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
                              return 'Please enter a password';
                            }
                            if (v.length < 6) {
                              return 'Use at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        20.sbh,
                        CustomButton(
                          text: 'Create account',
                          onPressed: _onCreateAccount,
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
                              onTap: navigateToLoginReplace,
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
