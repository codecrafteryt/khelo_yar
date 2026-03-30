/*
  ---------------------------------------
  Airbnb-style horizontal listing row for the explore bottom sheet.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/explore_venue.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';

class ExploreVenueSheetTile extends StatelessWidget {
  final ExploreVenue venue;
  final VoidCallback? onTap;

  const ExploreVenueSheetTile({
    super.key,
    required this.venue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 88.w,
                  height: 88.w,
                  child: Image.network(
                    venue.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: MyColors.darkWhite,
                      child: Icon(Icons.sports_soccer, color: MyColors.grayscale30, size: 36.sp),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: MyColors.darkWhite,
                        child: Center(
                          child: SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: MyColors.brandPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: MyColors.blackDark,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${venue.sport} · ${venue.area}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: MyColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16.sp, color: MyColors.blackDark),
                        SizedBox(width: 2.w),
                        Text(
                          '${venue.rating}',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyColors.blackDark,
                          ),
                        ),
                        Text(
                          ' (${venue.reviews})',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 13.sp,
                            color: MyColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rs ${venue.pricePkr}',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: MyColors.blackDark,
                          ),
                        ),
                        Text(
                          ' / hr',
                          style: TextStyle(
                            fontFamily: MyFonts.plusJakartaSans,
                            fontSize: 12.sp,
                            color: MyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
