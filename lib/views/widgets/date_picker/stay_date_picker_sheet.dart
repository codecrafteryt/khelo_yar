/*
  Draggable bottom sheet for stay dates — shell matches location / address picker.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';

import '../../../data/models/stay_date_selection.dart';
import '../../../data/stay_date_formatters.dart';
import '../../../controller/home_host_controller.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../../../utils/values/style.dart';
import '../custom_button.dart';
import '../custom_header_bar_widget.dart';
import 'date_calendar_widget.dart';

/// Top corner radius (aligned with [location_picker_dialog] / listing sheet).
const double _kStayDateSheetTopRadius = 20;

/// Opens draggable stay-date sheet. Dismiss without **Done** reverts the picker snapshot.
Future<void> showStayDatePickerSheet(BuildContext context) async {
  final hc = Get.find<HomeHostController>();
  hc.beginStayDatePickerSnapshot();

  final keep = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    isDismissible: true,
    enableDrag: true,
    builder: (ctx) => const _StayDatePickerSheetScaffold(),
  );

  hc.finalizeStayDatePickerSheet(keepChanges: keep == true);
}

class _StayDatePickerSheetScaffold extends StatelessWidget {
  const _StayDatePickerSheetScaffold();

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height;

    return SizedBox(
      height: maxH,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        minChildSize: 0.38,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.55, 0.88],
        builder: (context, scrollController) {
          return Material(
            color: MyColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(_kStayDateSheetTopRadius.r)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomHeaderBarWidget(
                  showClear: false,
                  radius: true,
                  functionClear: () {},
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                  child: Text(
                    'Select Dates',
                    style: kSize18DarkW800Text.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),

                Expanded(
                  child: GetBuilder<HomeHostController>(
                    builder: (hc) {
                      final bounds = hc.stayCalendarBounds;
                      return DateCalendarWidget(
                        checkIn: hc.sessionStayDates.checkIn,
                        checkOut: hc.sessionStayDates.checkOut,
                        minDate: bounds.$1,
                        maxDate: bounds.$2,
                        scrollController: scrollController,
                        onRangeChanged: hc.saveTemporaryStayDates,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h + bottomSafe),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.find<HomeHostController>().clearSessionStayDates();
                        },
                        child: Text(
                          'Clear dates',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: MyColors.blackDark,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 160.w,
                        child: CustomButton(
                          text: 'Done',
                          onPressed: () => Navigator.of(context).pop(true),
                          width: double.infinity,
                          borderRadius: 12.r,
                          backgroundColor: MyColors.brandPrimary,
                          borderColor: MyColors.brandPrimary,
                          textColor: MyColors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
