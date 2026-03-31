import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';
import '../../../../utils/values/my_color.dart';
import '../../../../utils/values/my_fonts.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_leading_icon.dart';
import '../../../widgets/custom_textfield.dart';

class ForgotPasswordReEnterPasswordScreen extends StatefulWidget {
  const ForgotPasswordReEnterPasswordScreen({super.key});

  @override
  State<ForgotPasswordReEnterPasswordScreen> createState() =>
      _ForgotPasswordReEnterPasswordScreenState();
}

class _ForgotPasswordReEnterPasswordScreenState
    extends State<ForgotPasswordReEnterPasswordScreen> {
  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorderColor = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);
  static const _bulletActiveColor = Color.fromRGBO(98, 101, 233, 1);
  static const _bulletInactiveColor = Color.fromRGBO(168, 172, 182, 1);

  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureRepeatPassword = true;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  bool get _hasMinLength {
    final length = _newPasswordController.text.length;
    return length >= 8 && length <= 16;
  }

  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_newPasswordController.text);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_newPasswordController.text);
  bool get _hasSpecialCharacter =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(_newPasswordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_newPasswordController.text);

  bool get _passwordRulesValid =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasSpecialCharacter &&
      _hasNumber;

  bool get _passwordsMatch =>
      _repeatPasswordController.text.isNotEmpty &&
      _newPasswordController.text == _repeatPasswordController.text;

  bool get _showNewPasswordError {
    if (_newPasswordController.text.isEmpty) return false;
    return !_passwordRulesValid;
  }

  bool get _showRepeatPasswordError {
    if (_repeatPasswordController.text.isEmpty) return false;
    return !_passwordsMatch;
  }

  bool get _canSubmit => _passwordRulesValid && _passwordsMatch;

  void _onUpdatePressed() {
    setState(() => _isSubmitted = true);
    if (!_canSubmit) return;
    // TODO: integrate reset password API flow.
  }

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
    final showMismatchError =
        _repeatPasswordController.text.isNotEmpty &&
        !_passwordsMatch &&
        (_isSubmitted || _showRepeatPasswordError);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              leading: CustomLeadingIcon(
                onPressed: () => Get.back(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'New password',
                        hintText: 'Enter new password',
                        controller: _newPasswordController,
                        isObscureText: _obscureNewPassword,
                        borderRadius: 12.r,
                        padding: EdgeInsets.zero,
                        borderColor: _showNewPasswordError ? _errorColor : _defaultBorderColor,
                        focusedBorderColor:
                            _showNewPasswordError ? _errorColor : Colors.black,
                        enabledBorderWidth: _showNewPasswordError ? 1 : 0.5,
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
                        labelColor: _showNewPasswordError ? _errorColor : Colors.black,
                        floatingLabelStyle: TextStyle(
                          fontFamily: MyFonts.plusJakartaSans,
                          fontSize: 14.sp,
                          color: _showNewPasswordError ? _errorColor : Colors.black,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black.withOpacity(0.6),
                            size: 20.sp,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      14.sbh,
                      _ruleItem(text: 'Must have 8 to 16 characters', active: _hasMinLength),
                      _ruleItem(text: 'Must have an uppercase character', active: _hasUppercase),
                      _ruleItem(text: 'Must have a lowercase character', active: _hasLowercase),
                      _ruleItem(
                        text: 'Must have a special character',
                        active: _hasSpecialCharacter,
                      ),
                      _ruleItem(text: 'Must have a number', active: _hasNumber),
                      20.sbh,
                      CustomTextField(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Repeat password',
                        hintText: 'Repeat your password',
                        controller: _repeatPasswordController,
                        isObscureText: _obscureRepeatPassword,
                        borderRadius: 12.r,
                        padding: EdgeInsets.zero,
                        borderColor: _showRepeatPasswordError ? _errorColor : _defaultBorderColor,
                        focusedBorderColor:
                            _showRepeatPasswordError ? _errorColor : Colors.black,
                        enabledBorderWidth: _showRepeatPasswordError ? 1 : 0.5,
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
                        labelColor: _showRepeatPasswordError ? _errorColor : Colors.black,
                        floatingLabelStyle: TextStyle(
                          fontFamily: MyFonts.plusJakartaSans,
                          fontSize: 14.sp,
                          color: _showRepeatPasswordError ? _errorColor : Colors.black,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscureRepeatPassword = !_obscureRepeatPassword,
                          ),
                          icon: Icon(
                            _obscureRepeatPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black.withOpacity(0.6),
                            size: 20.sp,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      if (showMismatchError) ...[
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
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
              child: CustomButton(
                text: 'Update',
                width: double.infinity,
                height: 74.h,
                borderRadius: 36.r,
                backgroundColor: MyColors.brandPrimary,
                borderColor: MyColors.brandPrimary,
                textColor: MyColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                onPressed: _onUpdatePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
