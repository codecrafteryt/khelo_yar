/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Outlined "Continue with Google" — use at bottom of auth screens.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleAuthButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.brandPrimary,
          backgroundColor: MyColors.white,
          side: const BorderSide(color: MyColors.borderSubtle, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.google,
              size: 18.sp,
              color: MyColors.brandPrimary,
            ),
            SizedBox(width: 12.w),
            Text(
              'Continue with Google',
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: MyColors.brandPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
