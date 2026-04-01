import 'package:intl/intl.dart';

import 'models/stay_date_selection.dart';

/// User-visible strings for stay date fields (explore bar + search sheet).
abstract final class StayDateFormatters {
  static final DateFormat _md = DateFormat('MMM d');
  static final DateFormat _weekdayMd = DateFormat('EEE, MMM d');

  /// Single line for the compact home search bar (committed state).
  static String committedSubtitle(StayDateSelection s) {
    if (!s.hasAnyDate) return 'Any date';
    final i = s.checkIn;
    final o = s.checkOut;
    if (i != null && o != null) {
      if (StayDateSelection.isSameDay(i, o)) return _weekdayMd.format(i);
      return '${_weekdayMd.format(i)} – ${_weekdayMd.format(o)}';
    }
    if (i != null) return '${_weekdayMd.format(i)} – Add checkout';
    return 'Any date';
  }

  /// Text inside the read-only Date field on the full search sheet.
  static String sheetDateFieldLine(StayDateSelection s) {
    if (!s.hasAnyDate) return 'Any date';
    final i = s.checkIn;
    final o = s.checkOut;
    if (i != null && o != null) {
      if (StayDateSelection.isSameDay(i, o)) return _md.format(i);
      return '${_md.format(i)} – ${_md.format(o)}';
    }
    if (i != null) return '${_md.format(i)} – Add checkout';
    return 'Any date';
  }

  static String checkInLabel(DateTime? d) =>
      d == null ? 'Check-in' : _md.format(d);

  static String checkOutLabel(DateTime? d) =>
      d == null ? 'Checkout' : _md.format(d);
}
