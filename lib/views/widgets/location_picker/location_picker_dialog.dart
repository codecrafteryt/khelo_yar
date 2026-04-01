/*
  Bottom sheet style location picker via [showGeneralDialog] + slide from bottom.
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/places_api.dart';
import 'address_picker_content.dart';

/// Fraction of screen height for the tall panel (90–92%).
const double _kLocationPickerHeightFraction = 0.91;

/// Top corner radius for the white shell.
const double _kLocationPickerTopRadius = 20;

bool _locationPickerOpen = false;

/// Opens the "Where" picker; returns a result [Map] or null if dismissed.
///
/// Keys: `result`, `lat`, `lng`, `postalCode`, `fromCurrentLocation`.
/// [barrierDismissible]: only honored in debug when true; release keeps explicit close.
Future<Map<String, dynamic>?> buildLocationPickerDialog(
  BuildContext context, {
  String hint = 'Search city or area',
  String title = 'Where',
  String? initialDescription,
  bool enableAutoSearch = false,
  bool barrierDismissible = false,
  String? countryBias,
  void Function(String description)? onLocationSelected,
  void Function(String description, double lat, double lng)? onLocationSelectedWithCoordinates,
  void Function(double lat, double lng)? onAutoSearchRefresh,
  bool showCurrentLocationRestriction = false,
  bool initiallyFromCurrentLocation = false,
}) async {
  if (_locationPickerOpen) return null;
  _locationPickerOpen = true;
  try {
    final key = dotenv.env['NEXT_PUBLIC_GOOGLE_MAPS_API_KEY'] ??
        dotenv.env['GOOGLE_PLACES_API_KEY'] ??
        dotenv.env['GOOGLE_MAPS_API_KEY'] ??
        '';
    final client = PlacesApiClient(apiKey: key, countryBias: countryBias);

    return await showGeneralDialog<Map<String, dynamic>?>(
      context: context,
      barrierDismissible: kDebugMode && barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: Align(alignment: Alignment.bottomCenter, child: child),
        );
      },
      pageBuilder: (ctx, animation, secondaryAnimation) {
        final h = MediaQuery.sizeOf(ctx).height;
        final bottomSafe = MediaQuery.paddingOf(ctx).bottom;
        final keyboard = MediaQuery.viewInsetsOf(ctx).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: keyboard),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: h * _kLocationPickerHeightFraction,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(_kLocationPickerTopRadius.r),
                ),
                clipBehavior: Clip.antiAlias,
                // Top safe area is NOT applied here: the sheet is ~91% height from the
                // bottom, so its rounded top already sits below the status bar; adding
                // SafeArea(top: true) duplicated inset and caused a large empty strip.
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomSafe),
                    child: AddressPickerContent(
                      places: client,
                      title: title,
                      hint: hint,
                      initialDescription: initialDescription,
                      enableAutoSearch: enableAutoSearch,
                      onLocationSelected: onLocationSelected,
                      onLocationSelectedWithCoordinates: onLocationSelectedWithCoordinates,
                      onAutoSearchRefresh: onAutoSearchRefresh,
                      showCurrentLocationRestriction: showCurrentLocationRestriction,
                      initiallyFromCurrentLocation: initiallyFromCurrentLocation,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  } finally {
    _locationPickerOpen = false;
  }
}
