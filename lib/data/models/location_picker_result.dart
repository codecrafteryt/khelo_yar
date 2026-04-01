/*
  Result payload returned when user confirms a location in the bottom picker.
*/

class LocationPickerResult {
  const LocationPickerResult({
    required this.result,
    this.lat,
    this.lng,
    this.postalCode,
    this.fromCurrentLocation = false,
  });

  final String result;
  final double? lat;
  final double? lng;
  final String? postalCode;
  final bool fromCurrentLocation;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'result': result,
        'lat': lat,
        'lng': lng,
        'postalCode': postalCode,
        'fromCurrentLocation': fromCurrentLocation,
      };

  static LocationPickerResult? fromMap(Map<String, dynamic>? raw) {
    if (raw == null) return null;
    final r = raw['result'];
    if (r is! String || r.isEmpty) return null;
    return LocationPickerResult(
      result: r,
      lat: (raw['lat'] as num?)?.toDouble(),
      lng: (raw['lng'] as num?)?.toDouble(),
      postalCode: raw['postalCode'] as String?,
      fromCurrentLocation: raw['fromCurrentLocation'] as bool? ?? false,
    );
  }
}
