/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: map controller
*/

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/explore_venue.dart';

class MapController extends GetxController {
  final SharedPreferences sharedPreferences;
  MapController({required this.sharedPreferences,});

  static const LatLng pakistanRoughCenter = LatLng(24.86, 67.01);
  static const List<String> sportFilters = [
    'All',
    'Futsal',
    'Indoor cricket',
    'Badminton',
    'Padel',
  ];

  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  String? selectedVenueId;
  String? selectedSportFilter = 'All';
  Set<Marker> markers = <Marker>{};

  List<ExploreVenue> filteredVenues(List<ExploreVenue> allVenues) {
    if (selectedSportFilter == null || selectedSportFilter == 'All') {
      return allVenues;
    }
    return allVenues
        .where((v) => v.sport.toLowerCase() == selectedSportFilter!.toLowerCase())
        .toList();
  }

  void initialize(List<ExploreVenue> allVenues, ValueChanged<ExploreVenue> onMarkerTap) {
    markers = buildMarkers(filteredVenues(allVenues), onMarkerTap);
  }

  Set<Marker> buildMarkers(
    List<ExploreVenue> venues,
    ValueChanged<ExploreVenue> onMarkerTap,
  ) {
    return venues.map((v) {
      final isSelected = v.id == selectedVenueId;
      return Marker(
        markerId: MarkerId(v.id),
        position: LatLng(v.lat, v.lng),
        zIndex: isSelected ? 2 : 1,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueCyan,
        ),
        onTap: () => onMarkerTap(v),
      );
    }).toSet();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!googleMapController.isCompleted) {
      googleMapController.complete(controller);
    }
  }

  void selectVenue(
    ExploreVenue venue,
    List<ExploreVenue> currentVenues,
    ValueChanged<ExploreVenue> onMarkerTap,
  ) {
    selectedVenueId = venue.id;
    markers = buildMarkers(currentVenues, onMarkerTap);
  }

  void clearSelection(
    List<ExploreVenue> currentVenues,
    ValueChanged<ExploreVenue> onMarkerTap,
  ) {
    selectedVenueId = null;
    markers = buildMarkers(currentVenues, onMarkerTap);
  }

  void applySportFilter(
    String filter,
    List<ExploreVenue> allVenues,
    ValueChanged<ExploreVenue> onMarkerTap,
  ) {
    selectedSportFilter = filter;
    selectedVenueId = null;
    markers = buildMarkers(filteredVenues(allVenues), onMarkerTap);
  }

  Future<void> animateToVenue(ExploreVenue venue) async {
    final controller = await googleMapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(venue.lat, venue.lng), 14.2),
    );
  }
}