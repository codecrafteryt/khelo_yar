/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: April 1, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Service's tab btn's
*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/map_controller.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

class ServiceTabButton extends StatelessWidget {
  const ServiceTabButton({
    super.key,
    required this.selectedSportFilter,
    required this.onSportFilterSelected,
  });

  final String selectedSportFilter;
  final ValueChanged<String> onSportFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => true,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MapController.sportFilters.map((label) {
            final selected = selectedSportFilter == label;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label: Text(
                  label,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? MyColors.brandPrimary
                        : MyColors.blackDark,
                  ),
                ),
                selected: selected,
                onSelected: (_) => onSportFilterSelected(label),
                backgroundColor: MyColors.white,
                selectedColor: const Color(0xFFEFF3FF),
                checkmarkColor: MyColors.brandPrimary,
                side: BorderSide(
                  color: selected
                      ? const Color(0xFFB9C7FF)
                      : MyColors.borderSubtle,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                showCheckmark: false,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
