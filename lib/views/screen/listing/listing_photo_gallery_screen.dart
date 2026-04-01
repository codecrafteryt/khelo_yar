/*
  Airbnb-style gallery: large hero [0], 2-column grid for remaining photos.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../widgets/listing/listing_network_image.dart';
import 'listing_photo_fullscreen_screen.dart';

class ListingPhotoGalleryScreen extends StatelessWidget {
  const ListingPhotoGalleryScreen({
    super.key,
    required this.imageUrls,
    required this.listingTitle,
  });

  final List<String> imageUrls;
  final String listingTitle;

  void _openFullscreen(BuildContext context, int index) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ListingPhotoFullscreenScreen(
          imageUrls: imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = imageUrls;
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: MyColors.blackDark, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          listingTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: MyColors.blackDark,
          ),
        ),
        centerTitle: false,
      ),
      body: urls.isEmpty
          ? Center(
              child: Text(
                'No photos',
                style: TextStyle(fontFamily: MyFonts.plusJakartaSans, color: MyColors.textSecondary),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GestureDetector(
                          onTap: () => _openFullscreen(context, 0),
                          child: ListingNetworkImage(imageUrl: urls.first),
                        ),
                      ),
                    ),
                  ),
                ),
                if (urls.length > 1)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, gridIndex) {
                          final photoIndex = gridIndex + 1;
                          if (photoIndex >= urls.length) return const SizedBox.shrink();
                          return GestureDetector(
                            onTap: () => _openFullscreen(context, photoIndex),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: ListingNetworkImage(imageUrl: urls[photoIndex]),
                            ),
                          );
                        },
                        childCount: urls.length - 1,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
