/*
  Full-screen search sheet (WHERE / DATE / SPORT) — Airbnb-style card.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';

class ExploreSearchFullSheet extends StatelessWidget {
  const ExploreSearchFullSheet({
    super.key,
    required this.onClose,
    required this.onUnderDevelopmentTap,
  });

  final VoidCallback onClose;
  final VoidCallback onUnderDevelopmentTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: MyColors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, topInset + 8.h, 16.w, bottomPad + 16.h),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onClose,
                  icon: Icon(Icons.close_rounded, size: 26.sp, color: MyColors.blackDark),
                  style: IconButton.styleFrom(backgroundColor: MyColors.darkWhite),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(color: MyColors.borderSubtle, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _WhereField(onTap: onUnderDevelopmentTap),
                        Divider(height: 1, thickness: 1, color: MyColors.borderSubtle),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _HalfField(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'DATE',
                                  hint: 'Any date',
                                  onTap: onUnderDevelopmentTap,
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: MyColors.borderSubtle,
                              ),
                              Expanded(
                                child: _HalfField(
                                  icon: Icons.stadium_outlined,
                                  label: 'SPORT',
                                  hint: 'Any sport',
                                  onTap: onUnderDevelopmentTap,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClose,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyColors.blackDark,
                        side: BorderSide(color: MyColors.borderSubtle),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: MyFonts.plusJakartaSans,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () {
                        onUnderDevelopmentTap();
                        onClose();
                      },
                      icon: Icon(Icons.search_rounded, size: 22.sp, color: MyColors.white),
                      label: Text(
                        'Search',
                        style: TextStyle(
                          fontFamily: MyFonts.plusJakartaSans,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: MyColors.brandPrimary,
                        foregroundColor: MyColors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class _WhereField extends StatelessWidget {
  const _WhereField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(Icons.search_rounded, size: 22.sp, color: MyColors.grayscale30),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHERE',
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: MyColors.grayscale30,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    readOnly: true,
                    onTap: onTap,
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: MyColors.blackDark,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'City or area…',
                      hintStyle: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 16.sp,
                        color: MyColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HalfField extends StatelessWidget {
  const _HalfField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(icon, size: 20.sp, color: MyColors.grayscale30),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: MyColors.grayscale30,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    readOnly: true,
                    onTap: onTap,
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: MyColors.blackDark,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: hint,
                      hintStyle: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 15.sp,
                        color: MyColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
