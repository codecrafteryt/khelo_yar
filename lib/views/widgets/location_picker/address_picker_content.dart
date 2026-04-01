/*
  Stateful "Where" body: debounced search, suggestions, current location row.
*/

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';
import 'package:khelo_yar/utils/values/style.dart';

import '../../../data/models/location_picker_result.dart';
import '../../../data/places_api.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../custom_header_bar_widget.dart';
import '../custom_textfield.dart';

/// Debounce delay for autocomplete requests (ms).
const int _kAutocompleteDebounceMs = 300;

/// Single horizontal inset for header, field, list — keeps left/right alignment consistent.
const double _kAddressPickerHorizontalPad = 16;

const Color _fieldErrorColor = Color.fromRGBO(240, 66, 72, 1);
const Color _fieldBorderColor = Color.fromRGBO(145, 148, 155, 1);
const Color _fieldHintColor = Color.fromRGBO(211, 211, 211, 1);

class AddressPickerContent extends StatefulWidget {
  const AddressPickerContent({
    super.key,
    required this.places,
    this.title = 'Where',
    this.hint = 'Search city or area',
    this.initialDescription,
    this.enableAutoSearch = false,
    this.onLocationSelected,
    this.onLocationSelectedWithCoordinates,
    this.onAutoSearchRefresh,
    this.showCurrentLocationRestriction = false,
    this.initiallyFromCurrentLocation = false,
  });

  final PlacesApiClient places;
  final String title;
  final String hint;
  final String? initialDescription;
  final bool enableAutoSearch;

  final void Function(String description)? onLocationSelected;
  final void Function(String description, double lat, double lng)? onLocationSelectedWithCoordinates;
  final void Function(double lat, double lng)? onAutoSearchRefresh;

  /// When true and [initiallyFromCurrentLocation] is true, hide "Use current location".
  final bool showCurrentLocationRestriction;
  final bool initiallyFromCurrentLocation;

  @override
  State<AddressPickerContent> createState() => _AddressPickerContentState();
}

class _AddressPickerContentState extends State<AddressPickerContent> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  List<PlacePrediction> _predictions = [];
  /// Autocomplete + place-details resolve (center indicator).
  bool _loading = false;
  /// GPS / geocode for "Use current location" only (row icon spinner, no center).
  bool _loadingCurrentLocation = false;
  String _draftOriginal = '';

  bool get _showCurrentRow {
    if (widget.showCurrentLocationRestriction && widget.initiallyFromCurrentLocation) {
      return false;
    }
    final q = _controller.text.trim();
    return q.length < 2;
  }

  @override
  void initState() {
    super.initState();
    _draftOriginal = widget.initialDescription ?? '';
    _controller = TextEditingController(text: _draftOriginal);
    _controller.addListener(() => setState(() {}));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scheduleSearch(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        _predictions = [];
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: _kAutocompleteDebounceMs), () async {
      final list = await widget.places.autocomplete(value.trim());
      if (!mounted) return;
      setState(() {
        _predictions = list;
        _loading = false;
      });
    });
  }

  Future<void> _popWithResult(LocationPickerResult data) async {
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(data.result);
    }
    if (widget.onLocationSelectedWithCoordinates != null &&
        data.lat != null &&
        data.lng != null) {
      widget.onLocationSelectedWithCoordinates!(data.result, data.lat!, data.lng!);
    }
    if (widget.enableAutoSearch && data.lat != null && data.lng != null) {
      widget.onAutoSearchRefresh?.call(data.lat!, data.lng!);
    }
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(data.toMap());
  }

  Future<void> _onPredictionTap(PlacePrediction p) async {
    setState(() => _loading = true);
    final details = await widget.places.placeDetails(p.placeId);
    if (!mounted) return;
    setState(() => _loading = false);
    if (details == null) return;
    await _popWithResult(
      LocationPickerResult(
        result: p.description,
        lat: details.lat,
        lng: details.lng,
        postalCode: details.postalCode,
        fromCurrentLocation: false,
      ),
    );
  }

  Future<void> _onUseCurrentLocation() async {
    if (_loadingCurrentLocation) return;
    setState(() => _loadingCurrentLocation = true);
    try {
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        if (!mounted) return;
        setState(() => _loadingCurrentLocation = false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        if (!mounted) return;
        setState(() => _loadingCurrentLocation = false);
        return;
      }
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() => _loadingCurrentLocation = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (!mounted) return;
      setState(() => _loadingCurrentLocation = false);
      if (marks.isEmpty) return;
      final pl = marks.first;
      final parts = <String>[
        if (pl.locality != null && pl.locality!.isNotEmpty) pl.locality!,
        if (pl.subAdministrativeArea != null && pl.subAdministrativeArea!.isNotEmpty)
          pl.subAdministrativeArea!,
        if (pl.administrativeArea != null && pl.administrativeArea!.isNotEmpty)
          pl.administrativeArea!,
        if (pl.country != null && pl.country!.isNotEmpty) pl.country!,
      ];
      final label = parts.isNotEmpty ? parts.join(', ') : '${pos.latitude}, ${pos.longitude}';

      await _popWithResult(
        LocationPickerResult(
          result: label,
          lat: pos.latitude,
          lng: pos.longitude,
          postalCode: pl.postalCode,
          fromCurrentLocation: true,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Current location error: $e');
      }
      if (mounted) setState(() => _loadingCurrentLocation = false);
    }
  }

  void _onCloseWithoutSave() {
    _controller.text = _draftOriginal;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final hPad = _kAddressPickerHorizontalPad.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8.h, hPad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomHeaderBarWidget(
                showClear: false,
                radius: true,
                functionClear: () {},
              ),
              Text(
                'Where',
                style: kSize18DarkW800Text.copyWith(
                  fontWeight: FontWeight.w600
                )
              ),
              12.sbh,
              CustomTextField(
                hintText: widget.hint,
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _scheduleSearch,
                prefixIcon: Icons.search_rounded,
                prefixIconColor: MyColors.grayscale30,
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear_rounded, size: 22.sp, color: MyColors.grayscale30),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _predictions = [];
                            _loading = false;
                            _loadingCurrentLocation = false;
                          });
                        },
                      ),
                borderRadius: 10.r,
                padding: EdgeInsets.zero,
                borderColor: _fieldBorderColor,
                focusedBorderColor: MyColors.brandPrimary,
                enabledBorderWidth: 0.5,
                focusedBorderWidth: 1.5,
                hintColor: _fieldHintColor,
                textColor: Colors.black,
                cursorColor: Colors.black,
                fillColor: Colors.transparent,
                focusedFillColor: Colors.transparent,
                fontSize: 14.sp,
                hintFontWeight: FontWeight.w400,
                errorBorderColor: _fieldErrorColor,
                errorBorderWidth: 1,
                focusedErrorBorderWidth: 1,
                keyboardType: TextInputType.streetAddress,
              ),
            ],
          ),
        ),
        if (_loading)
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 8.h, hPad, 8.h),
            child: Center(
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CupertinoActivityIndicator(),
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 4.h, hPad, 12.h + bottomInset),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              children: [
                if (_showCurrentRow)
                  InkWell(
                    onTap: _loadingCurrentLocation ? null : _onUseCurrentLocation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          _loadingCurrentLocation
                              ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: const CupertinoActivityIndicator(),
                          )
                              : SvgPicture.asset(
                            MyImages.currentLocationFlatSvg,
                            width: 22.w,
                            height: 22.w,
                            colorFilter:
                            const ColorFilter.mode(MyColors.black, BlendMode.srcIn),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Use current location',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: MyColors.blackDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ..._predictions.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final p = entry.value;

                    return Column(
                      children: [
                        InkWell(
                          onTap: (_loading || _loadingCurrentLocation)
                              ? null
                              : () => _onPredictionTap(p),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                p.description,
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 15.sp,
                                  color: MyColors.blackDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index != _predictions.length - 1)
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: MyColors.grayscale30,
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
