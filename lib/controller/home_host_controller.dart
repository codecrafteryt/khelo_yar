/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Home host controller — sheet ↔ map ↔ header coordination
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/explore_venue.dart';
import '../data/models/location_picker_result.dart';
import '../data/models/stay_date_selection.dart';
import '../data/stay_date_formatters.dart';
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
    imageUrl: 'https://images.unsplash.com/photo-1534158914592-062992fbe900?w=800&q=80',
    galleryUrls: [
      'https://images.unsplash.com/photo-1540747913341-92bdd855d18e?w=800&q=80',
      'https://images.unsplash.com/photo-1519861531473-9250234332d1?w=800&q=80',
      'https://images.unsplash.com/photo-1593341646782-e0b495cff86d?w=800&q=80',
      'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972?w=800&q=80',
    ],
    aboutArena:
        'Premium indoor nets with pace-friendly surfaces, video analysis bays, and floodlit evening slots.',
    amenities: ['6 nets', 'Pro shop', 'Café', 'Parking', 'Coaching'],
    groundRules: 'Non-marking shoes required. Helmets mandatory for hardball sessions.',
    addressLine: 'Block 8, Clifton, Karachi',
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
    imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80',
    galleryUrls: [
      'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=800&q=80',
      'https://images.unsplash.com/photo-1529900740174-0b5ee1953aae?w=800&q=80',
      'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=800&q=80',
    ],
    aboutArena: 'FIFA-spec turf, climate-controlled hall, and leagues every weekend.',
    amenities: ['2 courts', 'Locker rooms', 'Floodlights', 'First aid'],
    groundRules: 'Indoor trainers only. Shin guards recommended.',
    addressLine: 'Street 12, DHA Phase 6, Karachi',
  ),
  ExploreVenue(
    id: '3',
    name: 'Lahore Squash Academy',
    area: 'Johar Town',
    city: 'Lahore',
    sport: 'Squash',
    pricePkr: 2800,
    rating: 4.8,
    reviews: 27,
    lat: 31.5204,
    lng: 74.3587,
    imageUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?w=800&q=80',
    galleryUrls: [
      'https://images.unsplash.com/photo-1554068865-24cecd6e9b8b?w=800&q=80',
      'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=800&q=80',
      'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800&q=80',
      'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=80',
    ],
    aboutArena:
        'PSF-affiliated squash academy with four championship courts and professional coaches.',
    amenities: ['4 courts', 'Glass back wall', 'PSF coaching', 'Locker room', 'Café'],
    groundRules: 'Squash shoes mandatory. Eye protection recommended.',
    addressLine: 'Block P, Johar Town, Lahore',
    capacityLabel: 'Up to 4 players',
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
    imageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd6e9b8b?w=800&q=80',
    galleryUrls: [
      'https://images.unsplash.com/photo-1595435934249-3447c158ad42?w=800&q=80',
      'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800&q=80',
    ],
    aboutArena: 'Panoramic glass courts and pro stringing on site.',
    amenities: ['3 courts', 'Pro shop', 'Parking'],
    groundRules: 'Court shoes required.',
    addressLine: 'F-7 Markaz, Islamabad',
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
    imageUrl: 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=800&q=80',
    galleryUrls: [
      'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80',
      'https://images.unsplash.com/photo-1529900740174-0b5ee1953aae?w=800&q=80',
    ],
    aboutArena: 'All-weather 5-a-side with shock-absorbing turf.',
    amenities: ['2 pitches', 'Floodlights', 'Water station'],
    groundRules: 'No metal studs.',
    addressLine: 'Near Expo Centre, Johar Town, Lahore',
  ),
];

class HomeHostController extends GetxController {
  final SharedPreferences sharedPreferences;
  HomeHostController({required this.sharedPreferences});

  late final MapController mapController;
  final DraggableScrollableController sheetController = DraggableScrollableController();

  static const double listingMinSize = 0.04;
  static const double listingMaxSize = 0.81;

  /// Starts near half-screen; [snapSizes] pulls drag release to ~50%.
  static const double listingInitialSize = 0.5;

  /// Visual height of edge header block (search + chips) for map padding — logical pixels.
  static const double headerBlockHeight = 118;

  /// Pixels header slides up when sheet is collapsed (t → 0).
  static const double headerHideTranslate = 112;

  // --- Thresholds (documented magic numbers) ---
  /// Bottom nav hidden when sheet is almost fully collapsed (map-first).
  static const double extentShowBottomNav = 0.15;
  /// Below this, map should receive pan/zoom; above, sheet/list owns vertical interaction.
  static const double extentMapTouchCutoff = 0.55;
  /// Map-first: search hidden when sheet is very collapsed.
  static const double extentTopBarOpacityStart = 0.30;
  /// After this, search is fully visible unless we’re in the “half sheet” band below.
  static const double extentTopBarOpacityEnd = 0.45;
  /// Half-sheet band (around [listingInitialSize]): search fully hidden.
  static const double extentSearchHiddenHalfHalfWidth = 0.12;
  /// Load more when list scroll is within this distance of the end (px).
  static const double listingLoadMoreLeadPx = 200;

  double sheetExtent = listingInitialSize;

  /// Drives overlay/header/FAB/nav without calling [update] on every drag (avoids rebuilding [DraggableScrollableSheet]).
  late final ValueNotifier<double> sheetExtentNotifier;

  bool _layoutCoordinationDone = false;

  bool searchSheetOpen = false;

  /// Picked "Where" label for search bar + map focus.
  String? searchLocationLabel;

  double? searchLat;
  double? searchLng;
  bool searchFromCurrentLocation = false;

  /// Committed stay dates (applied when user confirms **Search** on explore sheet).
  StayDateSelection committedStayDates = const StayDateSelection();

  /// Working copy while explore / date sheet are open.
  StayDateSelection sessionStayDates = const StayDateSelection();

  StayDateSelection? _stayDatePickerSnapshot;

  /// Calendar bounds: today (local) through end of next calendar year.
  (DateTime, DateTime) get stayCalendarBounds {
    final now = DateTime.now();
    final min = DateTime(now.year, now.month, now.day);
    final max = DateTime(now.year + 1, 12, 31);
    return (min, max);
  }

  /// Second line under location (reflects [committedStayDates]).
  String searchDateSubtitle = StayDateFormatters.committedSubtitle(const StayDateSelection());

  /// Venue list (grows with mock pagination).
  final List<ExploreVenue> _allVenues = List<ExploreVenue>.from(kExploreMockVenues);
  int _paginationGeneration = 0;
  bool _loadingMore = false;

  ScrollController? _listingScrollController;

  List<ExploreVenue> get filteredVenues => mapController.filteredVenues(_allVenues);

  double normalizedSheetProgress(double extent) {
    final e = extent.clamp(listingMinSize, listingMaxSize);
    return ((e - listingMinSize) / (listingMaxSize - listingMinSize)).clamp(0.0, 1.0);
  }

  /// Bottom bar: extent < 0.15 → hide; extent >= 0.15 → show (see [extentShowBottomNav]).
  bool get showBottomNav => sheetExtent >= extentShowBottomNav;

  /// Sheet is "down" / map-first when extent is low — map receives gestures.
  bool get sheetIsDown => sheetExtent <= extentMapTouchCutoff;

  /// When sheet is "up", block map taps in the visible map strip (handled in UI overlay).
  bool get sheetBlocksMapTouches => sheetExtent > extentMapTouchCutoff;

  /// Search / chips row: hidden when sheet is very low, **fully hidden when sheet ~half** (user request),
  /// otherwise visible (with a short fade right above the collapsed zone).
  double get topSearchBarOpacity {
    final e = sheetExtent.clamp(0.0, 1.0);
    if (e <= extentTopBarOpacityStart) return 0;
    // Listing sheet ~50% height (snap default): hide search completely.
    if ((e - listingInitialSize).abs() <= extentSearchHiddenHalfHalfWidth) {
      return 0;
    }
    if (e >= extentTopBarOpacityEnd) return 1;
    final t = (e - extentTopBarOpacityStart) /
        (extentTopBarOpacityEnd - extentTopBarOpacityStart);
    return t.clamp(0.0, 1.0);
  }

  /// Map + Filters pill — show when sheet is not fully collapsed (original behavior).
  bool get showFloatingActions => sheetExtent > listingMinSize + 0.02;

  @override
  void onInit() {
    super.onInit();
    sheetExtentNotifier = ValueNotifier<double>(listingInitialSize);
    mapController = Get.find<MapController>();
    mapController.initialize(_allVenues, onVenueFocused);
  }

  @override
  void onClose() {
    _listingScrollController?.removeListener(_onListingScroll);
    sheetExtentNotifier.dispose();
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

  /// When Explore tab is shown again, expand sheet toward max (short curve).
  void resetSheetExpandedOnExploreVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!sheetController.isAttached) return;
      unawaited(
        sheetController.animateTo(
          listingMaxSize,
          duration: const Duration(milliseconds: 340),
          curve: Curves.easeOutCubic,
        ),
      );
    });
  }

  void attachListingScrollController(ScrollController sc) {
    if (_listingScrollController == sc) return;
    _listingScrollController?.removeListener(_onListingScroll);
    _listingScrollController = sc;
    _listingScrollController!.addListener(_onListingScroll);
  }

  void _onListingScroll() {
    final c = _listingScrollController;
    if (c == null || !c.hasClients || _loadingMore) return;
    final max = c.position.maxScrollExtent;
    if (max <= 0) return;
    if (c.position.pixels >= max - listingLoadMoreLeadPx) {
      _loadMoreMock();
    }
  }

  Future<void> _loadMoreMock() async {
    if (_loadingMore) return;
    _loadingMore = true;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _paginationGeneration++;
    final gen = _paginationGeneration;
    for (final v in kExploreMockVenues) {
      _allVenues.add(
        ExploreVenue(
          id: '${v.id}_more_${gen}_${_allVenues.length}',
          name: v.name,
          area: v.area,
          city: v.city,
          sport: v.sport,
          pricePkr: v.pricePkr,
          rating: v.rating,
          reviews: v.reviews,
          lat: v.lat,
          lng: v.lng,
          imageUrl: v.imageUrl,
          galleryUrls: v.galleryUrls,
          aboutArena: v.aboutArena,
          amenities: v.amenities,
          groundRules: v.groundRules,
          addressLine: v.addressLine,
          capacityLabel: v.capacityLabel,
        ),
      );
    }
    mapController.initialize(_allVenues, onVenueFocused);
    _loadingMore = false;
    update();
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
    mapController.applySportFilter(label, _allVenues, onVenueFocused);
    update();
  }

  void onSheetExtentChanged(double extent, Size screenSize, double topPadding) {
    final clamped = extent.clamp(listingMinSize, listingMaxSize);
    sheetExtent = clamped;
    sheetExtentNotifier.value = clamped;
    final t = normalizedSheetProgress(clamped);

    final bottomInset = clamped * screenSize.height;
    mapController.applySheetCoordination(
      sheetProgress: t,
      extent: clamped,
      padding: EdgeInsets.only(
        left: 0,
        right: 0,
        top: topPadding + headerBlockHeight,
        bottom: bottomInset,
      ),
    );
    // Do NOT call update() here — it rebuilds the whole Explore tree and can
    // dispose/recreate [DraggableScrollableSheet] while [sheetController] is still attached.
  }

  Future<void> collapseSheetToMap() async {
    if (!sheetController.isAttached) return;
    await sheetController.animateTo(
      listingMinSize,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void onMenuTap() {
    Get.snackbar('Menu', 'Coming soon');
  }

  void onSearchTap() {
    sessionStayDates = committedStayDates.copy();
    searchSheetOpen = true;
    update();
  }

  void closeSearchSheet() {
    searchSheetOpen = false;
    sessionStayDates = committedStayDates.copy();
    update();
  }

  /// Snapshot [sessionStayDates] before opening the date sheet; paired with [finalizeStayDatePickerSheet].
  void beginStayDatePickerSnapshot() {
    _stayDatePickerSnapshot = sessionStayDates.copy();
  }

  /// After sheet closes: revert to snapshot if user did not tap **Done**.
  void finalizeStayDatePickerSheet({required bool keepChanges}) {
    if (!keepChanges && _stayDatePickerSnapshot != null) {
      sessionStayDates = _stayDatePickerSnapshot!.copy();
    }
    _stayDatePickerSnapshot = null;
    update();
  }

  /// Updates draft selection from the calendar (temporary until explore **Search** or sheet revert).
  void saveTemporaryStayDates(StayDateSelection selection) {
    sessionStayDates = selection;
    update();
  }

  void clearSessionStayDates() {
    sessionStayDates = const StayDateSelection();
    update();
  }

  /// Persists session dates to committed state and closes the explore search overlay.
  void commitExploreSearchAndClose() {
    committedStayDates = sessionStayDates.copy();
    searchDateSubtitle = StayDateFormatters.committedSubtitle(committedStayDates);
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

  /// Called after [buildLocationPickerDialog] returns; updates state + map camera.
  Future<void> applyLocationPickerResult(Map<String, dynamic>? map) async {
    final picked = LocationPickerResult.fromMap(map);
    if (picked == null) return;
    searchLocationLabel = picked.result;
    searchLat = picked.lat;
    searchLng = picked.lng;
    searchFromCurrentLocation = picked.fromCurrentLocation;
    if (picked.lat != null && picked.lng != null) {
      await mapController.animateToLatLng(picked.lat!, picked.lng!);
    }
    update();
  }
}
