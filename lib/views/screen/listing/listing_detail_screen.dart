/*
  Airbnb-style listing detail — collapsing image carousel + sections.
  [ListingDetailController] must be registered (e.g. Get.put) before this route.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controller/listing_detail_controller.dart';
import '../../../data/models/listing_review.dart';
import '../../../utils/values/airbnb_map_style.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../widgets/listing/listing_network_image.dart';
import '../../widgets/listing/listing_reviews_bottom_sheet.dart';
import 'listing_location_map_fullscreen_screen.dart';
import 'listing_photo_gallery_screen.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  @override
  void dispose() {
    if (Get.isRegistered<ListingDetailController>()) {
      Get.delete<ListingDetailController>();
    }
    super.dispose();
  }

  void _openGallery(ListingDetailController c) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ListingPhotoGalleryScreen(
          imageUrls: c.photoUrls,
          listingTitle: c.venue.name,
        ),
      ),
    );
  }

  void _openReviews(ListingDetailController c) {
    showListingReviewsBottomSheet(
      context,
      totalReviews: c.venue.reviews,
      averageRating: c.venue.rating,
      starDistributionPercent: c.starDistributionPercent,
      reviews: c.reviews,
    );
  }

  void _openLocationMapFullscreen({
    required double lat,
    required double lng,
    String? title,
  }) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ListingLocationMapFullscreenScreen(
          lat: lat,
          lng: lng,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ListingDetailController>();
    final v = c.venue;
    final urls = c.photoUrls;
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 380.h,
              backgroundColor: MyColors.white,
              elevation: innerBoxIsScrolled ? 0.5 : 0,
              surfaceTintColor: Colors.transparent,
              title: innerBoxIsScrolled
                  ? Text(
                      v.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.blackDark,
                      ),
                    )
                  : null,
              leading: Padding(
                padding: EdgeInsets.only(left: 8.w, top: 8.h),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp, color: MyColors.blackDark),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              leadingWidth: 48.w,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (urls.isEmpty)
                      ColoredBox(
                        color: MyColors.darkWhite,
                        child: Icon(Icons.image_not_supported_outlined, size: 56.sp, color: MyColors.grayscale30),
                      )
                    else
                      PageView.builder(
                        controller: c.carouselPageController,
                        onPageChanged: c.onCarouselPageChanged,
                        itemCount: urls.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _openGallery(c),
                            child: ListingNetworkImage(imageUrl: urls[i]),
                          );
                        },
                      ),
                    Positioned(
                      top: topPad + 10.h,
                      right: 12.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (urls.isNotEmpty)
                            Obx(() => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    '${c.carouselIndex.value + 1}/${urls.length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                          SizedBox(width: 8.w),
                          Material(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: IconButton(
                              icon: Icon(Icons.share_outlined, size: 20.sp, color: MyColors.blackDark),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Obx(() => Material(
                                color: Colors.white.withValues(alpha: 0.92),
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: IconButton(
                                  icon: Icon(
                                    c.isFavorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 22.sp,
                                    color: c.isFavorite.value ? Colors.redAccent : MyColors.blackDark,
                                  ),
                                  onPressed: c.toggleFavorite,
                                ),
                              )),
                        ],
                      ),
                    ),
                    if (urls.length > 1)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 56.h,
                        child: Obx(() {
                          final cur = c.carouselIndex.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(urls.length, (i) {
                              return Container(
                                width: i == cur ? 8.w : 6.w,
                                height: 6.h,
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  color: i == cur ? Colors.white : Colors.white.withValues(alpha: 0.45),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    Positioned(
                      right: 16.w,
                      bottom: 16.h,
                      child: Material(
                        color: MyColors.white,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10.r),
                        child: InkWell(
                          onTap: () => _openGallery(c),
                          borderRadius: BorderRadius.circular(10.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.grid_view_rounded, size: 18.sp, color: MyColors.blackDark),
                                SizedBox(width: 8.w),
                                Text(
                                  'Show all photos',
                                  style: TextStyle(
                                    fontFamily: MyFonts.plusJakartaSans,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.blackDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              v.name,
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.blackDark,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.star_rounded, size: 18.sp, color: MyColors.blackDark),
                SizedBox(width: 4.w),
                Text(
                  '${v.rating}',
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                  ),
                ),
                Text(
                  ' (${v.reviews} reviews)',
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 14.sp,
                    color: MyColors.textSecondary,
                  ),
                ),
                Text(' · ', style: TextStyle(color: MyColors.textSecondary, fontSize: 14.sp)),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16.sp, color: MyColors.brandPrimary),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          v.locationSubtitle,
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: MyColors.brandPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _SportTag(label: v.sport),
                if (v.capacityLabel != null) _CapacityTag(label: v.capacityLabel!),
              ],
            ),
            SizedBox(height: 20.h),
            Divider(height: 1, color: MyColors.borderSubtle),
            SizedBox(height: 20.h),
            _SectionTitle('About this arena'),
            SizedBox(height: 8.h),
            Text(
              v.aboutArena ?? 'Details coming soon.',
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 15.sp,
                height: 1.45,
                color: const Color(0xFF484848),
              ),
            ),
            SizedBox(height: 20.h),
            Divider(height: 1, color: MyColors.borderSubtle),
            SizedBox(height: 20.h),
            _SectionTitle('What this arena offers'),
            SizedBox(height: 12.h),
            ..._amenityRows(v.amenities ?? const []),
            SizedBox(height: 20.h),
            Divider(height: 1, color: MyColors.borderSubtle),
            SizedBox(height: 20.h),
            _SectionTitle('Ground rules'),
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                v.groundRules ?? 'Please follow venue guidelines.',
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 14.sp,
                  height: 1.45,
                  color: const Color(0xFF44403C),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _SectionTitle('Location'),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18.sp, color: MyColors.brandPrimary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    v.addressLine ?? v.locationSubtitle,
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 14.sp,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 200.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(v.lat, v.lng),
                        zoom: 14.75,
                      ),
                      style: kAirbnbLikeMapStyle,
                      markers: {
                        Marker(
                          markerId: const MarkerId('listing_location_preview'),
                          position: LatLng(v.lat, v.lng),
                        ),
                      },
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      liteModeEnabled: true,
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => _openLocationMapFullscreen(
                          lat: v.lat,
                          lng: v.lng,
                          title: v.addressLine ?? v.locationSubtitle,
                        ),
                        behavior: HitTestBehavior.translucent,
                        child: const ColoredBox(color: Colors.transparent),
                      ),
                    ),
                    Positioned(
                      left: 12.w,
                      right: 12.w,
                      bottom: 10.h,
                      child: IgnorePointer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.fullscreen_rounded, size: 18.sp, color: Colors.white),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Tap for full map',
                                    style: TextStyle(
                                      fontFamily: MyFonts.plusJakartaSans,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28.h),
            Divider(height: 1, color: MyColors.borderSubtle),
            SizedBox(height: 20.h),
            Row(
              children: [
                Icon(Icons.star_rounded, size: 20.sp, color: MyColors.blackDark),
                SizedBox(width: 6.w),
                Text(
                  '${v.rating} · ${v.reviews} reviews',
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            _RatingSummaryInline(
              average: v.rating,
              distribution: c.starDistributionPercent,
            ),
            SizedBox(height: 16.h),
            if (c.reviews.isNotEmpty) _ReviewPreviewCard(review: c.reviews.first),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: () => _openReviews(c),
              style: OutlinedButton.styleFrom(
                foregroundColor: MyColors.blackDark,
                side: BorderSide(color: MyColors.blackDark, width: 1),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              child: Text(
                'Show all reviews',
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1D1E),
      ),
    );
  }
}

class _SportTag extends StatelessWidget {
  const _SportTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F5),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: MyFonts.plusJakartaSans,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: MyColors.brandPrimary,
        ),
      ),
    );
  }
}

class _CapacityTag extends StatelessWidget {
  const _CapacityTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: MyColors.scaffoldMuted,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline_rounded, size: 16.sp, color: MyColors.blackDark),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: MyColors.blackDark,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _amenityRows(List<String> amenities) {
  if (amenities.isEmpty) {
    return [
      Text(
        'Amenities will appear here.',
        style: TextStyle(fontFamily: MyFonts.plusJakartaSans, color: MyColors.textSecondary, fontSize: 14.sp),
      ),
    ];
  }
  return amenities
      .map(
        (a) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_rounded, size: 20.sp, color: MyColors.brandPrimary),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  a,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 15.sp,
                    color: const Color(0xFF484848),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
      .toList();
}

class _RatingSummaryInline extends StatelessWidget {
  const _RatingSummaryInline({
    required this.average,
    required this.distribution,
  });

  final double average;
  final Map<int, double> distribution;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: MyColors.borderSubtle.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            average.toStringAsFixed(1),
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.blackDark,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (_) => Icon(Icons.star_rounded, size: 18.sp, color: const Color(0xFFFFC107))),
          ),
          Text(
            'out of 5',
            style: TextStyle(fontFamily: MyFonts.plusJakartaSans, fontSize: 12.sp, color: MyColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          for (var s = 5; s >= 1; s--)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  SizedBox(width: 20.w, child: Text('$s', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600))),
                  Icon(Icons.star_rounded, size: 12.sp, color: const Color(0xFFFFC107)),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.r),
                      child: LinearProgressIndicator(
                        value: (distribution[s] ?? 0) / 100,
                        minHeight: 5.h,
                        backgroundColor: MyColors.borderSubtle.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          (distribution[s] ?? 0) > 0 ? const Color(0xFFFFC107) : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  SizedBox(
                    width: 32.w,
                    child: Text(
                      (distribution[s] ?? 0) > 0 ? '${distribution[s]!.toStringAsFixed(0)}%' : '—',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 11.sp, color: MyColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewPreviewCard extends StatelessWidget {
  const _ReviewPreviewCard({required this.review});

  final ListingReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: MyColors.borderSubtle, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: MyColors.brandPrimary,
                child: Icon(Icons.person_rounded, color: MyColors.white, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      review.dateLabel,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 12.sp,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.rating.toStringAsFixed(1),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 14.sp,
              height: 1.4,
              color: const Color(0xFF484848),
            ),
          ),
        ],
      ),
    );
  }
}
