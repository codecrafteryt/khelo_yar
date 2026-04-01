/*
  Draggable reviews sheet (Airbnb-style), opened from listing detail.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/listing_review.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

const double _kReviewsSheetTopRadius = 20;

Future<void> showListingReviewsBottomSheet(
  BuildContext context, {
  required int totalReviews,
  required double averageRating,
  required Map<int, double> starDistributionPercent,
  required List<ListingReview> reviews,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    isDismissible: true,
    enableDrag: true,
    builder: (ctx) => _ReviewsSheetScaffold(
      totalReviews: totalReviews,
      averageRating: averageRating,
      starDistributionPercent: starDistributionPercent,
      reviews: reviews,
    ),
  );
}

class _ReviewsSheetScaffold extends StatelessWidget {
  const _ReviewsSheetScaffold({
    required this.totalReviews,
    required this.averageRating,
    required this.starDistributionPercent,
    required this.reviews,
  });

  final int totalReviews;
  final double averageRating;
  final Map<int, double> starDistributionPercent;
  final List<ListingReview> reviews;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.94;

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: maxH,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.92,
            minChildSize: 0.35,
            maxChildSize: 0.96,
            snap: true,
            snapSizes: const [0.55, 0.92],
            builder: (context, scrollController) {
              return Material(
                color: MyColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(_kReviewsSheetTopRadius.r)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
                      child: Center(
                        child: Container(
                          width: 36.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: MyColors.borderSubtle,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 8.h, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$totalReviews reviews',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: MyColors.blackDark,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, color: MyColors.blackDark, size: 26.sp),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              Icons.star_rounded,
                              size: 18.sp,
                              color: i < averageRating.floor()
                                  ? const Color(0xFFFFC107)
                                  : MyColors.borderSubtle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${averageRating.toStringAsFixed(1)} overall',
                            style: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: MyColors.blackDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _SortChipsRow(),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h + bottom),
                        children: [
                          _RatingSummaryCard(
                            averageRating: averageRating,
                            starDistributionPercent: starDistributionPercent,
                          ),
                          SizedBox(height: 20.h),
                          for (final r in reviews) ...[
                            _ReviewTile(review: r),
                            SizedBox(height: 16.h),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SortChipsRow extends StatefulWidget {
  @override
  State<_SortChipsRow> createState() => _SortChipsRowState();
}

class _SortChipsRowState extends State<_SortChipsRow> {
  int _sortIndex = 0;
  static const _labels = ['Most relevant', 'Newest', 'Oldest', 'Highest rated', 'Lowest rated'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _labels.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final sel = i == _sortIndex;
          return FilterChip(
            label: Text(
              _labels[i],
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: sel ? MyColors.white : MyColors.blackDark,
              ),
            ),
            selected: sel,
            onSelected: (_) => setState(() => _sortIndex = i),
            backgroundColor: MyColors.white,
            selectedColor: MyColors.brandPrimary,
            checkmarkColor: Colors.white,
            showCheckmark: false,
            side: BorderSide(color: sel ? MyColors.brandPrimary : MyColors.borderSubtle),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
          );
        },
      ),
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  const _RatingSummaryCard({
    required this.averageRating,
    required this.starDistributionPercent,
  });

  final double averageRating;
  final Map<int, double> starDistributionPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: MyColors.scaffoldMuted,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.blackDark,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Icon(Icons.star_rounded, size: 20.sp, color: const Color(0xFFFFC107)),
            ),
          ),
          Text(
            'out of 5',
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              color: MyColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          for (var star = 5; star >= 1; star--)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    child: Text(
                      '$star',
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFFFC107)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: (starDistributionPercent[star] ?? 0) / 100,
                        minHeight: 6.h,
                        backgroundColor: MyColors.borderSubtle.withValues(alpha: 0.35),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          (starDistributionPercent[star] ?? 0) > 0
                              ? const Color(0xFFFFC107)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 36.w,
                    child: Text(
                      (starDistributionPercent[star] ?? 0) > 0
                          ? '${starDistributionPercent[star]!.toStringAsFixed(0)}%'
                          : '—',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 11.sp,
                        color: MyColors.textSecondary,
                      ),
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

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ListingReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: MyColors.borderSubtle, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: MyColors.brandPrimary,
                child: Icon(Icons.person_rounded, color: MyColors.white, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.blackDark,
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
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: i < review.rating.floor() ? const Color(0xFFFFC107) : MyColors.borderSubtle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.body,
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
