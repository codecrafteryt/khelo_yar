/*
  ---------------------------------------
  Project: KheloYaar — explore / map listing model (mock UI data).
*/

class ExploreVenue {
  final String id;
  final String name;
  final String area;
  final String city;
  final String sport;
  final int pricePkr;
  final double rating;
  final int reviews;
  final double lat;
  final double lng;
  final String imageUrl;

  const ExploreVenue({
    required this.id,
    required this.name,
    required this.area,
    required this.city,
    required this.sport,
    required this.pricePkr,
    required this.rating,
    required this.reviews,
    required this.lat,
    required this.lng,
    required this.imageUrl,
  });
}
