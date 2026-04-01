/*
  Full-screen map for a single listing location (from listing detail).
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/values/airbnb_map_style.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

class ListingLocationMapFullscreenScreen extends StatelessWidget {
  const ListingLocationMapFullscreenScreen({
    super.key,
    required this.lat,
    required this.lng,
    this.title,
  });

  final double lat;
  final double lng;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final target = LatLng(lat, lng);
    return Scaffold(
      backgroundColor: MyColors.white,
      // appBar: AppBar(
      //   backgroundColor: MyColors.white,
      //   surfaceTintColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: MyColors.blackDark),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   title: Text(
      //     title ?? 'Location',
      //     style: TextStyle(
      //       fontFamily: MyFonts.plusJakartaSans,
      //       fontWeight: FontWeight.w700,
      //       fontSize: 16.sp,
      //       color: MyColors.blackDark,
      //     ),
      //   ),
      // ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: target, zoom: 15.5),
        style: kAirbnbLikeMapStyle,
        markers: {
          Marker(
            markerId: const MarkerId('listing_location'),
            position: target,
          ),
        },
        mapToolbarEnabled: false,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: true,
      ),
    );
  }
}
