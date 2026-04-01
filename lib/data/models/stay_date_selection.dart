/*
  Check-in / check-out pair for stay search (date-only, local calendar).
*/

class StayDateSelection {
  const StayDateSelection({this.checkIn, this.checkOut});

  final DateTime? checkIn;
  final DateTime? checkOut;

  bool get hasAnyDate => checkIn != null || checkOut != null;

  bool get isCompleteRange =>
      checkIn != null && checkOut != null && !checkOut!.isBefore(checkIn!);

  StayDateSelection copy() => StayDateSelection(checkIn: checkIn, checkOut: checkOut);

  /// Normalizes to local date at midnight.
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool isSameDay(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);

  @override
  bool operator ==(Object other) =>
      other is StayDateSelection &&
      checkIn == other.checkIn &&
      checkOut == other.checkOut;

  @override
  int get hashCode => Object.hash(checkIn, checkOut);
}
