/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: April 1, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Horizontal sport chips — same catalog + emoji as sport picker sheet;
  Airbnb-style soft elevation; selection = border + label color only (white fill).
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/sport_picker_catalog.dart';
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

  static List<BoxShadow> get _chipShadows => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.09),
          blurRadius: 3,
          offset: const Offset(0, 1),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => true,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final item in SportPickerCatalog.gridItems)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: _SportFilterChip(
                  item: item,
                  selected: selectedSportFilter == item.filterValue,
                  shadows: _chipShadows,
                  onTap: () {
                    debugPrint(
                      'Sport chip: name="${item.label}", service_id=${item.serviceId}',
                    );
                    onSportFilterSelected(item.filterValue);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SportFilterChip extends StatelessWidget {
  const _SportFilterChip({
    required this.item,
    required this.selected,
    required this.shadows,
    required this.onTap,
  });

  final SportGridItem item;
  final bool selected;
  final List<BoxShadow> shadows;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: selected ? MyColors.brandPrimary : MyColors.borderSubtle,
              width: selected ? 1 : 0.5,
            ),
            boxShadow: shadows,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.emoji,
                  style: TextStyle(fontSize: 17.sp, height: 1.1),
                ),
                SizedBox(width: 6.w),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 120.w),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: MyColors.blackDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
