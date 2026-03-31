/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: map controller
*/

import 'dart:async';
import 'dart:ui' show lerpDouble;

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

  /// Insets so the map “center” respects overlays (header + bottom sheet). Updated with sheet coordination.
  EdgeInsets mapPadding = EdgeInsets.zero;

  /// Collapsed sheet → zoomed in (closer). Expanded sheet → zoomed out (overview).
  static const double zoomSheetCollapsed = 13.4;
  static const double zoomSheetExpanded = 10.4;

  double _lastCoordinationZoom = -1;
  DateTime? _lastCameraMoveAt;

  /// `sheetProgress`: 0 = collapsed, 1 = fully expanded (normalized from draggable extent).
  void applySheetCoordination({
    required double sheetProgress,
    required EdgeInsets padding,
  }) {
    mapPadding = padding;
    final t = sheetProgress.clamp(0.0, 1.0);
    final zoom = lerpDouble(zoomSheetCollapsed, zoomSheetExpanded, t)!;

    var shouldMoveCamera = (_lastCoordinationZoom - zoom).abs() >= 0.04;
    if (shouldMoveCamera) {
      final now = DateTime.now();
      if (_lastCameraMoveAt != null &&
          now.difference(_lastCameraMoveAt!).inMilliseconds < 32) {
        shouldMoveCamera = false;
      } else {
        _lastCameraMoveAt = now;
      }
    }
    if (shouldMoveCamera) {
      _lastCoordinationZoom = zoom;
      _moveCameraToOverviewZoom(zoom);
    }
    update();
  }

  Future<void> _moveCameraToOverviewZoom(double zoom) async {
    try {
      final c = await googleMapController.future;
      await c.moveCamera(
        CameraUpdate.newLatLngZoom(pakistanRoughCenter, zoom),
      );
    } catch (_) {}
  }

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
    update();
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
    update();
  }

  void clearSelection(
    List<ExploreVenue> currentVenues,
    ValueChanged<ExploreVenue> onMarkerTap,
  ) {
    selectedVenueId = null;
    markers = buildMarkers(currentVenues, onMarkerTap);
    update();
  }

  void applySportFilter(
    String filter,
    List<ExploreVenue> allVenues,
    ValueChanged<ExploreVenue> onMarkerTap,
  ) {
    selectedSportFilter = filter;
    selectedVenueId = null;
    markers = buildMarkers(filteredVenues(allVenues), onMarkerTap);
    update();
  }

  Future<void> animateToVenue(ExploreVenue venue) async {
    final controller = await googleMapController.future;
    _lastCoordinationZoom = 14.2;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(venue.lat, venue.lng), 14.2),
    );
  }
}