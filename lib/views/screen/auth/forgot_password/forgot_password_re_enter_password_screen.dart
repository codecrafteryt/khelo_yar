import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controller/auth_controller.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';
import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_leading_icon.dart';
import '../../../widgets/custom_textfield.dart';

class ForgotPasswordReEnterPasswordScreen extends StatelessWidget {
  const ForgotPasswordReEnterPasswordScreen({super.key});
  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorderColor = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);
  static const _bulletActiveColor = Color.fromRGBO(98, 101, 233, 1);
  static const _bulletInactiveColor = Color.fromRGBO(168, 172, 182, 1);

  Widget _ruleItem({
    required String text,
    required bool active,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 14.sp,
              color: active ? _bulletActiveColor : _bulletInactiveColor,
              height: 1.2,
            ),
          ),
          10.sbw,
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 10.sp,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? _bulletActiveColor : _bulletInactiveColor,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              leading: CustomLeadingIcon(
                onPressed: authController.goBack,
              ),
              title: Text(
                "Update your password",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: MyFonts.plusJakartaSans,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 20.h),
                child: Form(
                  child: GetBuilder<AuthController>(
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Obx(
                            () => CustomTextField(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'New password',
                              hintText: 'Enter new password',
                              controller: authController.resetNewPasswordController,
                              isObscureText: authController.resetObscureNewPassword.value,
                              borderRadius: 12.r,
                              padding: EdgeInsets.zero,
                              borderColor: authController.showNewPasswordError ? _errorColor : _defaultBorderColor,
                              focusedBorderColor:
                                  authController.showNewPasswordError ? _errorColor : Colors.black,
                              enabledBorderWidth: authController.showNewPasswordError ? 1 : 0.5,
                              focusedBorderWidth: 1,
                              errorBorderColor: _errorColor,
                              errorBorderWidth: 1,
                              focusedErrorBorderWidth: 1,
                              hintColor: _hintColor,
                              hintFontWeight: FontWeight.w400,
                              textColor: Colors.black,
                              cursorColor: Colors.black,
                              fillColor: Colors.transparent,
                              focusedFillColor: Colors.transparent,
                              fontSize: 14.sp,
                              labelColor: authController.showNewPasswordError ? _errorColor : Colors.black,
                              floatingLabelStyle: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 14.sp,
                                color: authController.showNewPasswordError ? _errorColor : Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: authController.toggleResetNewPasswordVisibility,
                                icon: Icon(
                                  authController.resetObscureNewPassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.black.withOpacity(0.6),
                                  size: 20.sp,
                                ),
                              ),
                              onChanged: (_) => authController.onResetPasswordInputChanged(),
                            ),
                          ),
                          14.sbh,
                          _ruleItem(text: 'Must have 8 to 16 characters', active: authController.hasMinLength),
                          _ruleItem(text: 'Must have an uppercase character', active: authController.hasUppercase),
                          _ruleItem(text: 'Must have a lowercase character', active: authController.hasLowercase),
                          _ruleItem(
                            text: 'Must have a special character',
                            active: authController.hasSpecialCharacter,
                          ),
                          _ruleItem(text: 'Must have a number', active: authController.hasNumber),
                          20.sbh,
                          Obx(
                            () => CustomTextField(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Repeat password',
                              hintText: 'Repeat your password',
                              controller: authController.resetRepeatPasswordController,
                              isObscureText: authController.resetObscureRepeatPassword.value,
                              borderRadius: 12.r,
                              padding: EdgeInsets.zero,
                              borderColor: authController.showRepeatPasswordError ? _errorColor : _defaultBorderColor,
                              focusedBorderColor:
                                  authController.showRepeatPasswordError ? _errorColor : Colors.black,
                              enabledBorderWidth: authController.showRepeatPasswordError ? 1 : 0.5,
                              focusedBorderWidth: 1,
                              errorBorderColor: _errorColor,
                              errorBorderWidth: 1,
                              focusedErrorBorderWidth: 1,
                              hintColor: _hintColor,
                              hintFontWeight: FontWeight.w400,
                              textColor: Colors.black,
                              cursorColor: Colors.black,
                              fillColor: Colors.transparent,
                              focusedFillColor: Colors.transparent,
                              fontSize: 14.sp,
                              labelColor: authController.showRepeatPasswordError ? _errorColor : Colors.black,
                              floatingLabelStyle: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 14.sp,
                                color: authController.showRepeatPasswordError ? _errorColor : Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: authController.toggleResetRepeatPasswordVisibility,
                                icon: Icon(
                                  authController.resetObscureRepeatPassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.black.withOpacity(0.6),
                                  size: 20.sp,
                                ),
                              ),
                              onChanged: (_) => authController.onResetPasswordInputChanged(),
                            ),
                          ),
                          if (authController.showMismatchError) ...[
                            5.sbh,
                            Text(
                              'Your passwords do not match, check them.',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: _errorColor,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
              child: CustomButton(
                text: 'Update',
                width: double.infinity,
                borderRadius: 12.r,
                backgroundColor: MyColors.brandPrimary,
                borderColor: MyColors.brandPrimary,
                textColor: MyColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                onPressed: authController.onUpdatePasswordPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
