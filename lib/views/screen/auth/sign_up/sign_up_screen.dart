/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Sign up — UI only; Google action at bottom.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/extensions/extentions.dart';
import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../../utils/values/my_images.dart';
import '../../../widgets/auth_labeled_field.dart';
import '../../../widgets/auth_or_divider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/google_auth_button.dart';
import '../auth_navigation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    // UI-only
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: MyColors.scaffoldMuted,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h + bottomInset),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 400.w),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    20.sbh,
                    Image.asset(
                      MyImages.kheloYaarLogo,
                      height: 44.h,
                      fit: BoxFit.contain,
                    ),
                    12.sbh,
                    Text(
                      'Joined by thousands of players',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: MyColors.textSecondary,
                      ),
                    ),
                    24.sbh,
                    AuthLabeledField(
                      label: 'Full name',
                      hint: 'Muhammad Ali',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    18.sbh,
                    AuthLabeledField(
                      label: 'Email',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
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
                    AuthLabeledField(
                      label: 'Password',
                      hint: 'Create a password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      helperText: 'Minimum 6 characters',
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
                    16.sbh,
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 0,
                      runSpacing: 4.h,
                      children: [
                        Text(
                          'By signing up, you agree to our ',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 12.sp,
                            color: MyColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Terms',
                            style: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 12.sp,
                              decoration: TextDecoration.underline,
                              color: MyColors.blackDark,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),
                        ),
                        Text(
                          ' and ',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 12.sp,
                            color: MyColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 12.sp,
                              decoration: TextDecoration.underline,
                              color: MyColors.blackDark,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),
                        ),
                        Text(
                          '.',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 12.sp,
                            color: MyColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
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
        ),
      ),
    );
  }
}
