/*
  Airbnb-style range calendar: [PagedVerticalCalendar] + custom day cells.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

import '../../../data/models/stay_date_selection.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

const double _kCalendarHorizontalPad = 16;

class DateCalendarWidget extends StatelessWidget {
  const DateCalendarWidget({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.minDate,
    required this.maxDate,
    required this.onRangeChanged,
    this.scrollController,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<StayDateSelection> onRangeChanged;
  final ScrollController? scrollController;

  DateTime get _initialScrollMonth {
    if (checkIn != null) {
      final d = StayDateSelection.dateOnly(checkIn!);
      if (!d.isBefore(minDate) && !d.isAfter(maxDate)) return d;
    }
    return minDate;
  }

  void _handleDayPressed(DateTime raw) {
    final day = StayDateSelection.dateOnly(raw);
    final today = StayDateSelection.dateOnly(DateTime.now());
    if (day.isBefore(today) || day.isBefore(minDate) || day.isAfter(maxDate)) {
      return;
    }

    DateTime? newIn = checkIn;
    DateTime? newOut = checkOut;

    final noRangeYet = checkIn == null;
    final rangeComplete = checkIn != null && checkOut != null;

    if (noRangeYet || rangeComplete) {
      newIn = day;
      newOut = null;
    } else {
      final start = StayDateSelection.dateOnly(checkIn!);
      if (day.isBefore(start)) {
        newIn = day;
        newOut = null;
      } else {
        newIn = start;
        newOut = day;
      }
    }

    onRangeChanged(StayDateSelection(checkIn: newIn, checkOut: newOut));
  }

  @override
  Widget build(BuildContext context) {
    final today = StayDateSelection.dateOnly(DateTime.now());

    return PagedVerticalCalendar(
      minDate: minDate,
      maxDate: maxDate,
      initialDate: _initialScrollMonth,
      startWeekWithSunday: true,
      scrollController: scrollController,
      dayAspectRatio: 1.05,
      listPadding: EdgeInsets.fromLTRB(_kCalendarHorizontalPad.w, 0, _kCalendarHorizontalPad.w, 24.h),
      physics: const ClampingScrollPhysics(),
      monthBuilder: (context, month, year) => _MonthHeading(month: month, year: year),
      onDayPressed: (date) => _handleDayPressed(date),
      dayBuilder: (context, date) {
        final d = StayDateSelection.dateOnly(date);
        final disabled = d.isBefore(today);
        final isStart = checkIn != null && StayDateSelection.isSameDay(checkIn!, date);
        final isEnd = checkOut != null && StayDateSelection.isSameDay(checkOut!, date);
        final sameStartEnd = isStart && isEnd;

        bool inShadedBand = false;
        if (!disabled && checkIn != null) {
          final s = StayDateSelection.dateOnly(checkIn!);
          if (checkOut == null) {
            inShadedBand = d == s;
          } else {
            final e = StayDateSelection.dateOnly(checkOut!);
            inShadedBand = !d.isBefore(s) && !d.isAfter(e);
          }
        }

        return _CalendarDayCell(
          dayNumber: date.day,
          disabled: disabled,
          inShadedBand: inShadedBand,
          isRangeStart: isStart,
          isRangeEnd: isEnd,
          sameStartEnd: sameStartEnd,
          waitingForCheckout: checkOut == null && checkIn != null,
        );
      },
    );
  }
}

class _MonthHeading extends StatelessWidget {
  const _MonthHeading({required this.month, required this.year});

  final int month;
  final int year;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy').format(DateTime(year, month));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: MyColors.blackDark,
            ),
          ),
        ),
        _WeekdayRow(),
        SizedBox(height: 4.h),
      ],
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  static const _labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final w in _labels)
          Expanded(
            child: Center(
              child: Text(
                w,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.textSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.dayNumber,
    required this.disabled,
    required this.inShadedBand,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.sameStartEnd,
    required this.waitingForCheckout,
  });

  final int dayNumber;
  final bool disabled;
  final bool inShadedBand;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool sameStartEnd;
  /// Only check-in chosen — band is a single pill, not a strip start-cap.
  final bool waitingForCheckout;

  BorderRadius _rangeBandBorderRadius() {
    final r = Radius.circular(17.r);
    if (waitingForCheckout && isRangeStart) {
      return BorderRadius.all(r);
    }
    if (isRangeStart && !isRangeEnd) {
      return BorderRadius.horizontal(left: r, right: Radius.zero);
    }
    if (!isRangeStart && isRangeEnd) {
      return BorderRadius.horizontal(left: Radius.zero, right: r);
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    final highlight = isRangeStart || isRangeEnd;

    if (disabled) {
      return Center(
        child: Text(
          '$dayNumber',
          style: TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: MyColors.grayscale20,
            decoration: TextDecoration.lineThrough,
            decorationColor: MyColors.grayscale20,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (inShadedBand && !sameStartEnd)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: MyColors.scaffoldMuted,
                  borderRadius: _rangeBandBorderRadius(),
                ),
              ),
            ),
          ),
        if (highlight)
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: MyColors.blackDark,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$dayNumber',
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: MyColors.white,
              ),
            ),
          )
        else
          Text(
            '$dayNumber',
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: MyColors.blackDark,
            ),
          ),
      ],
    );
  }
}
