/*
  Explore sport grid: filter keys, labels, and emoji shown in [SportPickerSheet].
*/

class SportGridItem {
  const SportGridItem({
    required this.filterValue,
    required this.label,
    required this.emoji,
  });

  /// Stored in [MapController.selectedSportFilter] (e.g. [allFilterValue]).
  final String filterValue;
  final String label;
  final String emoji;
}

abstract final class SportPickerCatalog {
  static const String allFilterValue = 'All';

  static const List<SportGridItem> gridItems = [
    SportGridItem(filterValue: allFilterValue, label: 'All sports', emoji: '🏟️'),
    SportGridItem(filterValue: 'Cricket', label: 'Cricket', emoji: '🏏'),
    SportGridItem(filterValue: 'Futsal', label: 'Futsal', emoji: '⚽'),
    SportGridItem(filterValue: 'Badminton', label: 'Badminton', emoji: '🏸'),
    SportGridItem(filterValue: 'Padel', label: 'Padel', emoji: '🎾'),
    SportGridItem(filterValue: 'Basketball', label: 'Basketball', emoji: '🏀'),
    SportGridItem(filterValue: 'Pickle Ball', label: 'Pickle Ball', emoji: '🎯'),
    SportGridItem(filterValue: 'Table Tennis', label: 'Table Tennis', emoji: '🏓'),
    SportGridItem(filterValue: 'Tennis', label: 'Tennis', emoji: '🎾'),
    SportGridItem(filterValue: 'Squash', label: 'Squash', emoji: '🟡'),
    SportGridItem(filterValue: 'Snooker', label: 'Snooker', emoji: '🎱'),
    SportGridItem(filterValue: 'E-Gaming', label: 'E-Gaming', emoji: '🎮'),
    SportGridItem(filterValue: 'Gym', label: 'Gym', emoji: '🏋️'),
  ];

  static String fieldDisplayText(String? filterValue) {
    final v = filterValue ?? allFilterValue;
    if (v == allFilterValue) return 'Any sport';
    for (final i in gridItems) {
      if (i.filterValue == v) return i.label;
    }
    return v;
  }
}
