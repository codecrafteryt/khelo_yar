/*
  ---------------------------------------
  KheloYaar — Airbnb-style explore: coordinated map + sheet + edge header.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_host_controller.dart';
import '../../../controller/map_controller.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../widgets/explore_search_full_sheet.dart';
import '../../widgets/explore_venue_sheet_tile.dart';
import '../map/map.dart';

class HomeExploreScreen extends StatefulWidget {
  const HomeExploreScreen({super.key});

  @override
  State<HomeExploreScreen> createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.find<HomeHostController>().ensureInitialCoordination(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeHostController>(
      builder: (c) {
        final topPad = MediaQuery.paddingOf(context).top;
        final bottomPad = MediaQuery.paddingOf(context).bottom;
        final venues = c.filteredVenues;

        return Scaffold(
          backgroundColor: MyColors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GetBuilder<MapController>(
                  builder: (mc) => ExploreMapView(
                    mapController: mc,
                    onMapTap: c.onMapTap,
                  ),
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  c.onSheetExtentChanged(
                    notification.extent,
                    MediaQuery.sizeOf(context),
                    MediaQuery.paddingOf(context).top,
                  );
                  return false;
                },
                child: DraggableScrollableSheet(
                  controller: c.sheetController,
                  initialChildSize: HomeHostController.listingInitialSize,
                  minChildSize: HomeHostController.listingMinSize,
                  maxChildSize: HomeHostController.listingMaxSize,
                  snap: true,
                  snapSizes: const [
                    HomeHostController.listingMinSize,
                    HomeHostController.listingInitialSize,
                    HomeHostController.listingMaxSize,
                  ],
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: MyColors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
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
                          ),
                          if (venues.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Text(
                                  'No venues for this sport yet',
                                  style: TextStyle(
                                    fontFamily: MyFonts.plusJakartaSans,
                                    fontSize: 15.sp,
                                    color: MyColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h + bottomPad),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index.isOdd) {
                                      return SizedBox(height: 12.h);
                                    }
                                    final v = venues[index ~/ 2];
                                    return ExploreVenueSheetTile(
                                      venue: v,
                                      onTap: () => c.onVenueFocused(v),
                                    );
                                  },
                                  childCount: venues.length * 2 - 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ValueListenableBuilder<double>(
                valueListenable: c.sheetProgressNotifier,
                builder: (context, t, _) {
                  final translate =
                      -HomeHostController.headerHideTranslate * (1 - t.clamp(0.0, 1.0));
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(0, translate),
                      child: Opacity(
                        opacity: t.clamp(0.0, 1.0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.w, topPad + 8.h, 16.w, 10.h),
                          decoration: BoxDecoration(
                            color: MyColors.white.withValues(alpha: 0.96),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _SearchPill(onSearchTap: c.onSearchTap)),
                                  SizedBox(width: 10.w),
                                  _RoundIconButton(
                                    icon: Icons.shopping_cart_outlined,
                                    onPressed: c.onMenuTap,
                                    badgeCount: 2,
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 38.h,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (n) => true,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: MapController.sportFilters.map((label) {
                                      final selected =
                                          c.mapController.selectedSportFilter == label;
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: FilterChip(
                                          label: Text(
                                            label,
                                            style: TextStyle(
                                              fontFamily: MyFonts.plusJakartaSans,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: selected
                                                  ? MyColors.brandPrimary
                                                  : MyColors.blackDark,
                                            ),
                                          ),
                                          selected: selected,
                                          onSelected: (_) => c.onSportFilterSelected(label),
                                          backgroundColor: MyColors.white,
                                          selectedColor: const Color(0xFFEFF3FF),
                                          checkmarkColor: MyColors.brandPrimary,
                                          side: BorderSide(
                                            color: selected
                                                ? const Color(0xFFB9C7FF)
                                                : MyColors.borderSubtle,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24.r),
                                          ),
                                          showCheckmark: false,
                                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (c.showFloatingActions)
                Positioned(
                  bottom: 18.h + bottomPad,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Material(
                      color: MyColors.brandPrimary,
                      elevation: 5,
                      borderRadius: BorderRadius.circular(24.r),
                      child: InkWell(
                        onTap: c.collapseSheetToMap,
                        borderRadius: BorderRadius.circular(24.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.map_outlined, size: 18.sp, color: MyColors.white),
                              SizedBox(width: 7.w),
                              Text(
                                'Map',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Icon(Icons.tune_rounded, size: 18.sp, color: MyColors.white),
                              SizedBox(width: 6.w),
                              Text(
                                'Filters',
                                style: TextStyle(
                                  fontFamily: MyFonts.plusJakartaSans,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (c.searchSheetOpen)
                Positioned.fill(
                  child: ExploreSearchFullSheet(
                    onClose: c.closeSearchSheet,
                    onUnderDevelopmentTap: c.onSearchFieldUnderDevelopment,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int? badgeCount;

  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44.w,
          height: 44.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(child: Icon(icon, size: 22.sp, color: MyColors.brandPrimary)),
              if ((badgeCount ?? 0) > 0)
                Positioned(
                  right: 2.w,
                  top: 2.h,
                  child: Container(
                    constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${badgeCount!}',
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        color: MyColors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _SearchPill({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.white,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onSearchTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                alignment: Alignment.center,
                child: Icon(Icons.search_rounded, size: 24.sp, color: MyColors.brandPrimary),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Miami Florida',
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: MyColors.blackDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Fri, Jan 31 - Mon, Feb 03 - 12 PM',
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, size: 22.sp, color: MyColors.brandPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
