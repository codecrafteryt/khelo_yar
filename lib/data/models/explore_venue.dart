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

  /// Extra listing photos (cover is always [imageUrl] first in [orderedPhotoUrls]).
  final List<String>? galleryUrls;

  final String? aboutArena;
  final List<String>? amenities;
  final String? groundRules;
  /// Single-line address for detail UI (e.g. "Block P, Johar Town, Lahore").
  final String? addressLine;

  /// Optional capacity chip (e.g. "Up to 4 players").
  final String? capacityLabel;

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
    this.galleryUrls,
    this.aboutArena,
    this.amenities,
    this.groundRules,
    this.addressLine,
    this.capacityLabel,
  });

  /// Cover first, then gallery URLs; skips empties and duplicates.
  List<String> get orderedPhotoUrls {
    final out = <String>[];
    final cover = imageUrl.trim();
    if (cover.isNotEmpty) out.add(cover);
    if (galleryUrls != null) {
      for (final u in galleryUrls!) {
        final t = u.trim();
        if (t.isNotEmpty && !out.contains(t)) out.add(t);
      }
    }
    return out;
  }

  String get locationSubtitle => '$area, $city';
}
