/*
  Thin Google Places REST client (autocomplete + place details).
  Keys: NEXT_PUBLIC_GOOGLE_MAPS_API_KEY, GOOGLE_PLACES_API_KEY, or GOOGLE_MAPS_API_KEY in .env (Places API enabled).
*/

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// One autocomplete suggestion from Places API.
class PlacePrediction {
  const PlacePrediction({required this.description, required this.placeId});

  final String description;
  final String placeId;
}

/// Resolved coordinates + optional postal code from Place Details.
class PlaceDetails {
  const PlaceDetails({
    required this.lat,
    required this.lng,
    this.formattedAddress,
    this.postalCode,
  });

  final double lat;
  final double lng;
  final String? formattedAddress;
  final String? postalCode;
}

/// Calls Google Places HTTP endpoints (legacy JSON API).
class PlacesApiClient {
  PlacesApiClient({required this.apiKey, this.countryBias});

  /// From [.env]; if empty, [autocomplete] / [placeDetails] return empty / null.
  final String apiKey;

  /// e.g. `pk` — optional region bias for autocomplete.
  final String? countryBias;

  static const String _autocompleteBase =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String _detailsBase =
      'https://maps.googleapis.com/maps/api/place/details/json';

  Future<List<PlacePrediction>> autocomplete(String input) async {
    if (apiKey.isEmpty || input.length < 2) return [];
    final uri = Uri.parse(_autocompleteBase).replace(
      queryParameters: <String, String>{
        'input': input,
        'key': apiKey,
        if (countryBias != null && countryBias!.isNotEmpty)
          'components': 'country:$countryBias',
      },
    );
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return [];
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final status = map['status'] as String? ?? '';
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        if (kDebugMode) {
          debugPrint('Places autocomplete: $status ${map['error_message']}');
        }
        return [];
      }
      final list = map['predictions'] as List<dynamic>? ?? [];
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        return PlacePrediction(
          description: m['description'] as String? ?? '',
          placeId: m['place_id'] as String? ?? '',
        );
      }).where((p) => p.placeId.isNotEmpty).toList();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Places autocomplete error: $e\n$st');
      }
      return [];
    }
  }

  Future<PlaceDetails?> placeDetails(String placeId) async {
    if (apiKey.isEmpty || placeId.isEmpty) return null;
    final uri = Uri.parse(_detailsBase).replace(
      queryParameters: <String, String>{
        'place_id': placeId,
        'key': apiKey,
        'fields': 'geometry,address_components,formatted_address',
      },
    );
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return null;
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final status = map['status'] as String? ?? '';
      if (status != 'OK') {
        if (kDebugMode) {
          debugPrint('Place details: $status ${map['error_message']}');
        }
        return null;
      }
      final result = map['result'] as Map<String, dynamic>?;
      if (result == null) return null;
      final geom = result['geometry'] as Map<String, dynamic>?;
      final loc = geom?['location'] as Map<String, dynamic>?;
      if (loc == null) return null;
      final lat = (loc['lat'] as num?)?.toDouble();
      final lng = (loc['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;

      String? postal;
      final components = result['address_components'] as List<dynamic>?;
      if (components != null) {
        for (final c in components) {
          final m = c as Map<String, dynamic>;
          final types = m['types'] as List<dynamic>? ?? [];
          if (types.contains('postal_code')) {
            postal = m['short_name'] as String? ?? m['long_name'] as String?;
            break;
          }
        }
      }

      return PlaceDetails(
        lat: lat,
        lng: lng,
        formattedAddress: result['formatted_address'] as String?,
        postalCode: postal,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Place details error: $e\n$st');
      }
      return null;
    }
  }
}
