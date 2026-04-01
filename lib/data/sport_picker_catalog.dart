/*
  Explore sport grid: filter keys, labels, emoji, and stable service_id (0…).
*/

class SportGridItem {
  const SportGridItem({
    required this.serviceId,
    required this.filterValue,
    required this.label,
    required this.emoji,
  });

  /// API / analytics id — **0** = all sports, then **1, 2, …** in [SportPickerCatalog.gridItems] order.
  final int serviceId;

  /// Stored in [MapController.selectedSportFilter] (e.g. [allFilterValue]).
  final String filterValue;
  final String label;
  final String emoji;
}

abstract final class SportPickerCatalog {
  static const String allFilterValue = 'All';

  static const List<SportGridItem> gridItems = [
    SportGridItem(serviceId: 0, filterValue: allFilterValue, label: 'All sports', emoji: '🏟️'),
    SportGridItem(serviceId: 1, filterValue: 'Cricket', label: 'Cricket', emoji: '🏏'),
    SportGridItem(serviceId: 2, filterValue: 'Futsal', label: 'Futsal', emoji: '⚽'),
    SportGridItem(serviceId: 3, filterValue: 'Badminton', label: 'Badminton', emoji: '🏸'),
    SportGridItem(serviceId: 4, filterValue: 'Padel', label: 'Padel', emoji: '🎾'),
    SportGridItem(serviceId: 5, filterValue: 'Basketball', label: 'Basketball', emoji: '🏀'),
    SportGridItem(serviceId: 6, filterValue: 'Pickle Ball', label: 'Pickle Ball', emoji: '🎯'),
    SportGridItem(serviceId: 7, filterValue: 'Table Tennis', label: 'Table Tennis', emoji: '🏓'),
    SportGridItem(serviceId: 8, filterValue: 'Tennis', label: 'Tennis', emoji: '🎾'),
    SportGridItem(serviceId: 9, filterValue: 'Squash', label: 'Squash', emoji: '🟡'),
    SportGridItem(serviceId: 10, filterValue: 'Snooker', label: 'Snooker', emoji: '🎱'),
    SportGridItem(serviceId: 11, filterValue: 'E-Gaming', label: 'E-Gaming', emoji: '🎮'),
    SportGridItem(serviceId: 12, filterValue: 'Gym', label: 'Gym', emoji: '🏋️'),
  ];

  static String fieldDisplayText(String? filterValue) {
    final v = filterValue ?? allFilterValue;
    if (v == allFilterValue) return 'Any sport';
    for (final i in gridItems) {
      if (i.filterValue == v) return i.label;
    }
    return v;
  }

  static SportGridItem? itemForServiceId(int serviceId) {
    for (final i in gridItems) {
      if (i.serviceId == serviceId) return i;
    }
    return null;
  }

  static SportGridItem? itemForFilterValue(String filterValue) {
    for (final i in gridItems) {
      if (i.filterValue == filterValue) return i;
    }
    return null;
  }
}
