/*
  Single review row for listing detail / reviews sheet.
*/

class ListingReview {
  const ListingReview({
    required this.authorName,
    required this.dateLabel,
    required this.rating,
    required this.body,
  });

  final String authorName;
  final String dateLabel;
  final double rating;
  final String body;
}
