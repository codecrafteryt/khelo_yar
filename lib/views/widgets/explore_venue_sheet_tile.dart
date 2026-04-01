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
    final hasTopHost = venue.rating >= 4.85;
    final isInstant = venue.sport.toLowerCase() == 'futsal' || venue.sport.toLowerCase() == 'indoor cricket';
    final hasDeal = venue.pricePkr >= 5000;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 170.h,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            venue.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: MyColors.darkWhite,
                              child: Icon(Icons.sports_soccer, color: MyColors.grayscale30, size: 44.sp),
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
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: CircleAvatar(
                              radius: 14.r,
                              backgroundColor: Colors.black.withValues(alpha: 0.26),
                              child: Icon(Icons.favorite_border_rounded, color: MyColors.white, size: 16.sp),
                            ),
                          ),
                          // if (isInstant)
                          //   Positioned(
                          //     top: 12.h,
                          //     left: 10.w,
                          //     child: _Badge(
                          //       label: 'Instant Book',
                          //       icon: Icons.bolt_rounded,
                          //       color: const Color(0xFFE53EAE),
                          //     ),
                          //   ),
                          // if (hasTopHost)
                          //   Positioned(
                          //     bottom: 12.h,
                          //     left: 10.w,
                          //     child: _Badge(
                          //       label: 'Top Host',
                          //       icon: Icons.verified_rounded,
                          //       color: MyColors.white,
                          //       textColor: MyColors.blackDark,
                          //     ),
                          //   ),
                          // if (hasDeal)
                          //   Positioned(
                          //     bottom: 12.h,
                          //     right: 12.w,
                          //     child: Container(
                          //       width: 56.w,
                          //       height: 56.w,
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: const Color(0xFF5B63F6),
                          //       ),
                          //       alignment: Alignment.center,
                          //       child: Text(
                          //         'DEAL',
                          //         style: TextStyle(
                          //           fontFamily: MyFonts.plusJakartaSans,
                          //           fontSize: 14.sp,
                          //           fontWeight: FontWeight.w700,
                          //           color: MyColors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            venue.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: MyColors.blackDark,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [

                              Text(
                                '${venue.rating}',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.blackDark,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Icon(Icons.star_rounded, size: 15.sp, color: const Color(0xFF5B63F6)),
                              SizedBox(width: 2.w),
                              Text(
                                '• ${venue.reviews} reviews',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 10.sp,
                                  color: MyColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${venue.pricePkr.toString()}+',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.blackDark,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'hour',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 14.sp,
                                  color: MyColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 15.sp, color: MyColors.blackDark),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  '15 mi from current location',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: MyFonts.plusJakartaSans,
                                    fontSize: 11.sp,
                                    color: MyColors.blackDark,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: textColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
