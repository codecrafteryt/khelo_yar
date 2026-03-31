import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controller/auth_controller.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';
import 'package:pinput/pinput.dart';
import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_leading_icon.dart';
import 'forgot_password_re_enter_password_screen.dart';

class ForgotPasswordOtpScreen extends StatelessWidget {
  ForgotPasswordOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(134, 142, 150, 1),
        ),
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color.fromRGBO(134, 142, 150, 1),
      ),
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.white,
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            /// ---------- TOP CONTENT ----------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    CustomAppBar(
                      leading: CustomLeadingIcon(
                        onPressed: authController.goBack,
                      ),
                      title: Text(
                        "Confirm your code",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: MyFonts.plusJakartaSans,
                        ),
                      ),
                    ),

                    35.sbh,

                    /// TITLE
                    Text(
                      "Verify it's you".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(52, 58, 64, 1),
                      ),
                    ),

                    12.sbh,

                    /// DESCRIPTION
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        "We emailed you a security code at your Email. "
                            "It may take a moment to arrive".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(120, 130, 138, 1),
                        ),
                      ),
                    ),

                    40.sbh,

                    /// OTP FIELD
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Pinput(
                          controller: authController.otpController,
                          length: AuthController.otpLength,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          showCursor: true,
                          onChanged: authController.onOtpChanged,
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          validator: (_) => authController.showOtpError.value ? '' : null,
                        ),
                    ),

                    30.sbh,

                    /// SIGNUP TEXT CENTER
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Didn’t receive any code? ',
                            style: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 15,
                              color: MyColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: authController.onResendOtp,
                            child: Obx(
                              () => Text(
                                authController.otpResendTimer.value > 0
                                    ? 'Resend code (${authController.otpResendTimer.value}s)'
                                    : 'Resend code',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: authController.otpResendTimer.value > 0
                                      ? const Color.fromRGBO(145, 148, 155, 1)
                                      : MyColors.blackDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ---------- BOTTOM BUTTON ----------
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
              child: CustomButton(
                text: 'Continue'.tr,
                width: double.infinity,
                borderRadius: 12.r,
                backgroundColor: MyColors.brandPrimary,
                borderColor: MyColors.brandPrimary,
                textColor: MyColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                onPressed: (){
                 // authController.onOtpContinue;
                  Get.to(() => const ForgotPasswordReEnterPasswordScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
