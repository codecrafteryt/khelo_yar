/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: April 1, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Explore — map + draggable sheet + coordinated header / FABs.
*/

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_host_controller.dart';
import '../../../controller/map_controller.dart';
import '../../../data/sport_picker_catalog.dart';
import '../../../data/stay_date_formatters.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../widgets/explore_search_full_sheet.dart';
import '../../widgets/date_picker/stay_date_picker_sheet.dart';
import '../../widgets/sport_picker/sport_picker_sheet.dart';
import '../../widgets/location_picker/location_picker_dialog.dart';
import '../../widgets/explore_venue_sheet_tile.dart';
import '../map/map.dart';
import '../search/home_search_bar.dart';
import '../services_tab_button/service_tab_button.dart';

class HomeExploreScreen extends StatefulWidget {
  const HomeExploreScreen({super.key});

  @override
  State<HomeExploreScreen> createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen> {
  int _buildCount = 0;

  void _debugLog(String hypothesisId, String message, Map<String, dynamic> data) {
    final payload = <String, dynamic>{
      'sessionId': 'a4c2a6',
      'runId': 'post-fix',
      'hypothesisId': hypothesisId,
      'location': 'home_explore_screen.dart',
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    File('/Users/chsalman/Desktop/khelo_yar/.cursor/debug-a4c2a6.log')
        .writeAsStringSync('${jsonEncode(payload)}\n', mode: FileMode.append);
  }

  @override
  void initState() {
    super.initState();
    final c = Get.find<HomeHostController>();
    // #region agent log
    _debugLog('H1', 'HomeExploreScreen.initState', {
      'stateHash': identityHashCode(this),
      'widgetHash': identityHashCode(widget),
      'controllerHash': identityHashCode(c),
      'sheetControllerHash': identityHashCode(c.sheetController),
      'sheetControllerAttached': c.sheetController.isAttached,
    });
    // #endregion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // #region agent log
      _debugLog('H3', 'HomeExploreScreen.postFrame before ensure/reset', {
        'stateHash': identityHashCode(this),
        'controllerHash': identityHashCode(c),
        'sheetControllerAttached': c.sheetController.isAttached,
      });
      // #endregion
      c.ensureInitialCoordination(context);
      c.resetSheetExpandedOnExploreVisible();
    });
  }

  @override
  void dispose() {
    final c = Get.find<HomeHostController>();
    // #region agent log
    _debugLog('H1', 'HomeExploreScreen.dispose', {
      'stateHash': identityHashCode(this),
      'widgetHash': identityHashCode(widget),
      'controllerHash': identityHashCode(c),
      'sheetControllerHash': identityHashCode(c.sheetController),
      'sheetControllerAttached': c.sheetController.isAttached,
    });
    // #endregion
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeHostController>();
    _buildCount++;
    // #region agent log
    _debugLog('H2', 'HomeExploreScreen.build', {
      'stateHash': identityHashCode(this),
      'buildCount': _buildCount,
      'controllerHash': identityHashCode(c),
      'sheetControllerHash': identityHashCode(c.sheetController),
      'sheetControllerAttached': c.sheetController.isAttached,
      'searchSheetOpen': c.searchSheetOpen,
      'mounted': mounted,
    });
    // #endregion

    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final screenH = MediaQuery.sizeOf(context).height;

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
          // Extent-driven overlay — must NOT wrap [DraggableScrollableSheet].
          ValueListenableBuilder<double>(
            valueListenable: c.sheetExtentNotifier,
            builder: (context, extent, _) {
              if (!c.sheetBlocksMapTouches) return const SizedBox.shrink();
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: screenH * (1 - extent).clamp(0.0, 1.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: const ColoredBox(color: Colors.transparent),
                ),
              );
            },
          ),
          Positioned.fill(
            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                c.onSheetExtentChanged(
                  notification.extent,
                  MediaQuery.sizeOf(context),
                  MediaQuery.paddingOf(context).top,
                );
                return false;
              },
              child: DraggableScrollableSheet(
                key: const ValueKey<Object>('kExploreDraggableSheet'),
                controller: c.sheetController,
                initialChildSize: HomeHostController.listingInitialSize,
                minChildSize: HomeHostController.listingMinSize,
                maxChildSize: HomeHostController.listingMaxSize,
                snap: true,
                snapSizes: const [HomeHostController.listingInitialSize],
                builder: (context, scrollController) {
                  return _ListingScrollAttach(
                    scrollController: scrollController,
                    child: GetBuilder<HomeHostController>(
                      builder: (c) {
                        final venues = c.filteredVenues;
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
                  );
                },
              ),
            ),
          ),
          GetBuilder<HomeHostController>(
            builder: (hc) {
              return ValueListenableBuilder<double>(
                valueListenable: hc.sheetExtentNotifier,
                builder: (context, extent, _) {
                  if (hc.searchSheetOpen) return const SizedBox.shrink();
                  // Half-sheet / map-first: no layout space for search row (fully gone).
                  if (hc.topSearchBarOpacity < 0.01) {
                    return const SizedBox.shrink();
                  }
                  final t = hc.normalizedSheetProgress(extent);
                  final hideOffset =
                      HomeHostController.headerHideTranslate + topPad + 16.h;
                  final translate = -hideOffset * (1 - t.clamp(0.0, 1.0));
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(0, translate),
                      child: Opacity(
                        opacity: hc.topSearchBarOpacity,
                        child: IgnorePointer(
                          ignoring: hc.topSearchBarOpacity < 0.02,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(16.w, topPad + 8.h, 16.w, 10.h),
                            decoration: BoxDecoration(
                              color: MyColors.white,
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
                                HomeSearchBar(
                                  onSearchTap: hc.onSearchTap,
                                  locationTitle: hc.searchLocationLabel ?? 'Where to?',
                                  dateSubtitle: hc.searchDateSubtitle,
                                ),
                                SizedBox(height: 12.h),
                                ServiceTabButton(
                                  selectedSportFilter:
                                      hc.mapController.selectedSportFilter ?? 'All',
                                  onSportFilterSelected: hc.onSportFilterSelected,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<double>(
            valueListenable: c.sheetExtentNotifier,
            builder: (context, extent, _) {
              if (!c.showFloatingActions) return const SizedBox.shrink();
              return Positioned(
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
              );
            },
          ),
          GetBuilder<HomeHostController>(
            builder: (c) {
              if (!c.searchSheetOpen) return const SizedBox.shrink();
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: c.closeSearchSheet,
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.32),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ExploreSearchFullSheet(
                      onClose: c.closeSearchSheet,
                      whereDisplayText: c.searchLocationLabel ?? '',
                      dateDisplayText:
                          StayDateFormatters.sheetDateFieldLine(c.sessionStayDates),
                      sportDisplayText: SportPickerCatalog.fieldDisplayText(
                        c.mapController.selectedSportFilter,
                      ),
                      onWhereTap: () async {
                        final map = await buildLocationPickerDialog(
                          context,
                          initialDescription: c.searchLocationLabel,
                          initiallyFromCurrentLocation: c.searchFromCurrentLocation,
                          countryBias: 'pk',
                        );
                        await c.applyLocationPickerResult(map);
                      },
                      onDateTap: () => showStayDatePickerSheet(context),
                      onSportTap: () => showSportPickerSheet(context),
                      onSearchPressed: c.commitExploreSearchAndClose,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Attaches the sheet’s [ScrollController] for “load more” + FAB scroll-to-top.
class _ListingScrollAttach extends StatefulWidget {
  const _ListingScrollAttach({
    required this.scrollController,
    required this.child,
  });

  final ScrollController scrollController;
  final Widget child;

  @override
  State<_ListingScrollAttach> createState() => _ListingScrollAttachState();
}

class _ListingScrollAttachState extends State<_ListingScrollAttach> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _attach());
  }

  @override
  void didUpdateWidget(covariant _ListingScrollAttach oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      _attach();
    }
  }

  void _attach() {
    if (!mounted) return;
    Get.find<HomeHostController>().attachListingScrollController(widget.scrollController);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
