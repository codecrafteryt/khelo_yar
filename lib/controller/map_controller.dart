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
import '../data/sport_picker_catalog.dart';

class MapController extends GetxController {
  final SharedPreferences sharedPreferences;
  MapController({required this.sharedPreferences,});

  static const LatLng pakistanRoughCenter = LatLng(24.86, 67.01);
  static List<String> get sportFilters =>
      SportPickerCatalog.gridItems.map((e) => e.filterValue).toList();

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

  /// Peek zoom when sheet is very low — slightly closer than default overview.
  static const double zoomPeekIn = 13.0;

  /// Extent thresholds (fraction of screen height) for optional peek zoom behavior.
  /// Below [extentPeekZoomIn]: zoom in slightly; at/above [extentRestoreZoom]: restore saved zoom.
  static const double extentPeekZoomIn = 0.12;
  static const double extentRestoreZoom = 0.45;

  double _lastCoordinationZoom = -1;
  DateTime? _lastCameraMoveAt;

  double? _savedZoomBeforePeek;

  /// `sheetProgress`: 0 = collapsed, 1 = fully expanded (normalized from draggable extent).
  /// [extent] is raw `DraggableScrollableNotification.extent` (0–1) for threshold-based peek zoom.
  void applySheetCoordination({
    required double sheetProgress,
    required EdgeInsets padding,
    required double extent,
  }) {
    mapPadding = padding;
    final t = sheetProgress.clamp(0.0, 1.0);
    final baseZoom = lerpDouble(zoomSheetCollapsed, zoomSheetExpanded, t)!;
    final e = extent.clamp(0.0, 1.0);

    // Optional peek zoom: sheet very low → slightly zoom in and remember prior zoom;
    // sheet high again → restore. Mid-range uses normal [baseZoom]. Debounce in [_maybeApplyZoom].
    double targetZoom = baseZoom;
    if (e <= extentPeekZoomIn) {
      _savedZoomBeforePeek ??=
          _lastCoordinationZoom > 0 ? _lastCoordinationZoom : baseZoom;
      targetZoom = zoomPeekIn;
    } else if (e >= extentRestoreZoom && _savedZoomBeforePeek != null) {
      targetZoom = _savedZoomBeforePeek!;
      _savedZoomBeforePeek = null;
    } else {
      // Left peek zone before crossing restore threshold — cancel stored zoom.
      if (e > extentPeekZoomIn &&
          e < extentRestoreZoom &&
          _savedZoomBeforePeek != null) {
        _savedZoomBeforePeek = null;
      }
      targetZoom = baseZoom;
    }

    _maybeApplyZoom(targetZoom);
    update();
  }

  void _maybeApplyZoom(double zoom) {
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
    if (selectedSportFilter == null ||
        selectedSportFilter == SportPickerCatalog.allFilterValue) {
      return allVenues;
    }
    final f = selectedSportFilter!.toLowerCase().trim();
    return allVenues.where((v) => _venueMatchesSport(v.sport, f)).toList();
  }

  static bool _venueMatchesSport(String venueSport, String filterLower) {
    final vs = venueSport.toLowerCase().trim();
    if (vs == filterLower) return true;
    if (filterLower == 'cricket' && vs.contains('cricket')) return true;
    if (vs.contains(filterLower)) return true;
    final words = filterLower.split(RegExp(r'\s+'));
    return words.isNotEmpty && words.every((w) => w.isEmpty || vs.contains(w));
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

  /// Moves camera to an arbitrary search / picker coordinate (e.g. "Where" selection).
  Future<void> animateToLatLng(double lat, double lng, {double zoom = 14}) async {
    try {
      final controller = await googleMapController.future;
      _lastCoordinationZoom = zoom;
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), zoom),
      );
    } catch (_) {}
  }
}