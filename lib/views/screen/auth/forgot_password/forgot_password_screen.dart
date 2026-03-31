import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';
import 'package:khelo_yar/views/screen/auth/forgot_password/forgot_password_otp_screen.dart';

import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_leading_icon.dart';
import '../../../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorder = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);
  @override
  Widget build(BuildContext context) {
    final _forgotController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
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
              title: Text("Reset your Password",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: MyFonts.plusJakartaSans,
                ),
              ),
            ),
            Form(
              //key: ,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h + MediaQuery.of(context).padding.bottom),
                  child: Column(
                    children: [
                      Text(
                        "Forgot Password".tr,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      12.sbh,
                      Text(
                        "Recover your account password".tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(120, 130, 138, 1),
                        ),
                      ),
                      40.sbh,
                      Form(
                       // key: controller.formKey2,
                        child: Column(
                          children: [
                            CustomTextField(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Email',
                              hintText: 'you@example.com',
                              controller: _forgotController,
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
                          ],
                        ),
                      ),
                      20.sbh,
                      CustomButton(
                            text: 'Continue'.tr,
                        width: double.infinity,
                        borderRadius: 12.r,
                        backgroundColor: MyColors.brandPrimary,
                        borderColor: MyColors.brandPrimary,
                        textColor: MyColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                            onPressed: () {
                              Get.to(() => ForgotPasswordOtpScreen(),);
                            },
                          ),

                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
