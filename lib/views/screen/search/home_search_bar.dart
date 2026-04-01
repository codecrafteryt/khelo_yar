/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: April 1, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Home host controller — sheet ↔ map ↔ header coordination
*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../../utils/values/style.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final String locationTitle;
  final String dateSubtitle;

  const HomeSearchBar({
    super.key,
    required this.onSearchTap,
    required this.locationTitle,
    required this.dateSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.white,
      elevation: 0.2,
      borderRadius: BorderRadius.circular(42.r),
      child: GestureDetector(
        onTap: onSearchTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
          child: Row(
            children: [
              SvgPicture.asset(
                MyImages.searchSvg,
                width: 22.w,
                height: 22.w,
                colorFilter: const ColorFilter.mode(MyColors.brandPrimary, BlendMode.srcIn),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locationTitle,
                      style: kSize13DarkW300Text.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dateSubtitle,
                      style: kSize13DarkW300Text.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                MyImages.arrowDownSvg,
                width: 22.w,
                height: 22.w,
                colorFilter: const ColorFilter.mode(MyColors.brandPrimary, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
