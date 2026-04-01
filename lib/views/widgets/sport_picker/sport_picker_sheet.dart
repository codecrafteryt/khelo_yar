/*
  White “CHOOSE A SPORT” bottom sheet — 3-column grid (light teal selection).
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_host_controller.dart';
import '../../../controller/map_controller.dart';
import '../../../data/sport_picker_catalog.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/style.dart';
import '../custom_header_bar_widget.dart';

const double _kSheetTopRadius = 20;

/// Sheet background — white.
const Color _kSportSheetBg = Colors.white;

/// Unselected tile fill (same as sheet).
const Color _kSportTileFill = Colors.white;

/// Unselected label — charcoal.
const Color _kSportLabelIdle = Color(0xFF252D3D);

/// Unselected tile border — subtle grey.
const Color _kSportTileBorderIdle = MyColors.borderSubtle;

/// Selected tile — light teal wash (on white).
const Color _kSportSelectedFill = Color(0xFFE8F4F5);

Future<void> showSportPickerSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    isDismissible: true,
    enableDrag: true,
    builder: (ctx) => const _SportPickerSheetBody(),
  );
}

class _SportPickerSheetBody extends StatelessWidget {
  const _SportPickerSheetBody();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.93;

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: _kSportSheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(_kSheetTopRadius.r)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: maxH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomHeaderBarWidget(
                  showClear: false,
                  radius: true,
                  functionClear: () {},
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
                  child: Text(
                    'Choose a sport',
                      style: kSize18DarkW800Text.copyWith(
                          fontWeight: FontWeight.w600
                      )
                  ),
                ),
                Expanded(
                  child: GetBuilder<MapController>(
                    builder: (mc) {
                      final selected = mc.selectedSportFilter ?? SportPickerCatalog.allFilterValue;
                      return GridView.builder(
                        padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 16.h + bottom),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.88,
                        ),
                        itemCount: SportPickerCatalog.gridItems.length,
                        itemBuilder: (context, index) {
                          final item = SportPickerCatalog.gridItems[index];
                          final isSelected = item.filterValue == selected;
                          return _SportTile(
                            item: item,
                            selected: isSelected,
                            onTap: () {
                              debugPrint(
                                'Sport sheet: name="${item.label}", service_id=${item.serviceId}',
                              );
                              Get.find<HomeHostController>().onSportFilterSelected(item.filterValue);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
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

class _SportTile extends StatelessWidget {
  const _SportTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SportGridItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelColor = selected ? MyColors.brandPrimary : _kSportLabelIdle;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? _kSportSelectedFill : _kSportTileFill,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected ? MyColors.brandPrimary : _kSportTileBorderIdle,
              width: selected ? 2 : 0.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: TextStyle(fontSize: 34.sp),
                    ),
                  ),
                ),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                    height: 1.15,
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
