/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: Home host controller — sheet ↔ map ↔ header coordination
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/explore_venue.dart';
import 'map_controller.dart';

/// Mock venues (Pakistan) — replace with API later.
final List<ExploreVenue> kExploreMockVenues = [
  ExploreVenue(
    id: '1',
    name: 'Velocity Indoor Cricket',
    area: 'Clifton',
    city: 'Karachi',
    sport: 'Indoor cricket',
    pricePkr: 3500,
    rating: 4.89,
    reviews: 128,
    lat: 24.8138,
    lng: 67.0299,
    imageUrl: 'https://images.unsplash.com/photo-1534158914592-062992fbe900?w=400&q=80',
  ),
  ExploreVenue(
    id: '2',
    name: 'Apex Futsal Arena',
    area: 'DHA Phase 6',
    city: 'Karachi',
    sport: 'Futsal',
    pricePkr: 4200,
    rating: 4.92,
    reviews: 256,
    lat: 24.8040,
    lng: 67.0670,
    imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&q=80',
  ),
  ExploreVenue(
    id: '3',
    name: 'Smash House Badminton',
    area: 'Gulberg III',
    city: 'Lahore',
    sport: 'Badminton',
    pricePkr: 2800,
    rating: 4.76,
    reviews: 89,
    lat: 31.5204,
    lng: 74.3587,
    imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400&q=80',
  ),
  ExploreVenue(
    id: '4',
    name: 'Padel Club Islamabad',
    area: 'F-7',
    city: 'Islamabad',
    sport: 'Padel',
    pricePkr: 5500,
    rating: 4.95,
    reviews: 64,
    lat: 33.7215,
    lng: 73.0433,
    imageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd6e9b8b?w=400&q=80',
  ),
  ExploreVenue(
    id: '5',
    name: 'Pro Turf 5-a-side',
    area: 'Johar Town',
    city: 'Lahore',
    sport: 'Futsal',
    pricePkr: 3100,
    rating: 4.71,
    reviews: 142,
    lat: 31.4697,
    lng: 74.2728,
    imageUrl: 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=400&q=80',
  ),
];

class HomeHostController extends GetxController {
  final SharedPreferences sharedPreferences;
  HomeHostController({required this.sharedPreferences});

  late final MapController mapController;
  final DraggableScrollableController sheetController = DraggableScrollableController();

  static const double listingMinSize = 0.04;
  static const double listingInitialSize = 0.81;
  static const double listingMaxSize = 0.94;

  /// Visual height of edge header block (search + chips) for map padding — logical pixels.
  static const double headerBlockHeight = 118;

  /// Pixels header slides up when sheet is collapsed (t → 0).
  static const double headerHideTranslate = 112;

  double sheetExtent = listingInitialSize;

  /// Single driver for UI: 0 = sheet collapsed, 1 = sheet expanded. Drives header + map (via [onSheetExtentChanged]).
  late final ValueNotifier<double> sheetProgressNotifier;

  bool _layoutCoordinationDone = false;

  bool searchSheetOpen = false;

  List<ExploreVenue> get filteredVenues => mapController.filteredVenues(kExploreMockVenues);

  double normalizedSheetProgress(double extent) {
    final e = extent.clamp(listingMinSize, listingMaxSize);
    return ((e - listingMinSize) / (listingMaxSize - listingMinSize)).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    mapController = Get.find<MapController>();
    mapController.initialize(kExploreMockVenues, onVenueFocused);
    sheetProgressNotifier = ValueNotifier<double>(normalizedSheetProgress(listingInitialSize));
  }

  @override
  void onClose() {
    sheetProgressNotifier.dispose();
    sheetController.dispose();
    super.onClose();
  }

  /// Call once after first layout so map padding / zoom match initial sheet size.
  void ensureInitialCoordination(BuildContext context) {
    if (_layoutCoordinationDone) return;
    _layoutCoordinationDone = true;
    final m = MediaQuery.of(context);
    onSheetExtentChanged(sheetExtent, m.size, m.padding.top);
  }

  Future<void> onVenueFocused(ExploreVenue v) async {
    mapController.selectVenue(v, filteredVenues, onVenueFocused);
    update();
    await mapController.animateToVenue(v);
  }

  void onMapTap() {
    mapController.clearSelection(filteredVenues, onVenueFocused);
    update();
  }

  void onSportFilterSelected(String label) {
    mapController.applySportFilter(label, kExploreMockVenues, onVenueFocused);
    update();
  }

  void onSheetExtentChanged(double extent, Size screenSize, double topPadding) {
    final clamped = extent.clamp(listingMinSize, listingMaxSize);
    sheetExtent = clamped;
    final t = normalizedSheetProgress(clamped);
    sheetProgressNotifier.value = t;

    final bottomInset = clamped * screenSize.height;
    mapController.applySheetCoordination(
      sheetProgress: t,
      padding: EdgeInsets.only(
        left: 0,
        right: 0,
        top: topPadding + headerBlockHeight,
        bottom: bottomInset,
      ),
    );
    update();
  }

  bool get showFloatingActions => sheetExtent > listingMinSize + 0.02;

  Future<void> collapseSheetToMap() async {
    if (!sheetController.isAttached) return;
    await sheetController.animateTo(
      listingMinSize,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void onMenuTap() {
    Get.snackbar('Menu', 'Coming soon');
  }

  void onSearchTap() {
    searchSheetOpen = true;
    update();
  }

  void closeSearchSheet() {
    searchSheetOpen = false;
    update();
  }

  void onSearchFieldUnderDevelopment() {
    Get.snackbar(
      'Coming soon',
      'This feature is under development.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
