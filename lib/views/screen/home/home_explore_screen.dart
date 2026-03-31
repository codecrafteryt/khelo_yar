/*
  ---------------------------------------
  KheloYaar — Airbnb-style explore: full-bleed map + draggable listing sheet.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/map_controller.dart';
import '../../../data/models/explore_venue.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../map/map.dart';
import '../../widgets/explore_venue_sheet_tile.dart';

/// Mock venues (Pakistan) — replace with API later.
final List<ExploreVenue> kExploreMockVenues = [
  ExploreVenue(
    id: '1',
    name: 'Velocity Indoor Cricket',
    area: 'Clifton',
    city: 'Karachi',
    sport: 'Indoor cricket',
    pricePkr: 3500,
    rating: 4.89,
    reviews: 128,
    lat: 24.8138,
    lng: 67.0299,
    imageUrl: 'https://images.unsplash.com/photo-1534158914592-062992fbe900?w=400&q=80',
  ),
  ExploreVenue(
    id: '2',
    name: 'Apex Futsal Arena',
    area: 'DHA Phase 6',
    city: 'Karachi',
    sport: 'Futsal',
    pricePkr: 4200,
    rating: 4.92,
    reviews: 256,
    lat: 24.8040,
    lng: 67.0670,
    imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&q=80',
  ),
  ExploreVenue(
    id: '3',
    name: 'Smash House Badminton',
    area: 'Gulberg III',
    city: 'Lahore',
    sport: 'Badminton',
    pricePkr: 2800,
    rating: 4.76,
    reviews: 89,
    lat: 31.5204,
    lng: 74.3587,
    imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400&q=80',
  ),
  ExploreVenue(
    id: '4',
    name: 'Padel Club Islamabad',
    area: 'F-7',
    city: 'Islamabad',
    sport: 'Padel',
    pricePkr: 5500,
    rating: 4.95,
    reviews: 64,
    lat: 33.7215,
    lng: 73.0433,
    imageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd6e9b8b?w=400&q=80',
  ),
  ExploreVenue(
    id: '5',
    name: 'Pro Turf 5-a-side',
    area: 'Johar Town',
    city: 'Lahore',
    sport: 'Futsal',
    pricePkr: 3100,
    rating: 4.71,
    reviews: 142,
    lat: 31.4697,
    lng: 74.2728,
    imageUrl: 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=400&q=80',
  ),
];

class HomeExploreScreen extends StatefulWidget {
  const HomeExploreScreen({super.key});

  @override
  State<HomeExploreScreen> createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen> {
  final MapController _mapController = Get.find();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _mapController.initialize(kExploreMockVenues, _onVenueFocused);
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  List<ExploreVenue> get _filteredVenues {
    return _mapController.filteredVenues(kExploreMockVenues);
  }

  Future<void> _onVenueFocused(ExploreVenue v) async {
    setState(() {
      _mapController.selectVenue(v, _filteredVenues, _onVenueFocused);
    });
    await _mapController.animateToVenue(v);
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ExploreMapView(
              mapController: _mapController,
              onMapTap: () {
                setState(() {
                  _mapController.clearSelection(_filteredVenues, _onVenueFocused);
                });
              },
            ),
          ),

          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.36,
            minChildSize: 0.13,
            maxChildSize: 0.94,
            snap: true,
            snapSizes: const [0.13, 0.36, 0.94],
            builder: (context, scrollController) {
              final venues = _filteredVenues;
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
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Center(
                            child: Container(
                              width: 36.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: MyColors.borderSubtle,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sports arenas',
                                        style: TextStyle(
                                          fontFamily: MyFonts.plusJakartaSans,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.blackDark,
                                          height: 1.15,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${venues.length} venues · Pakistan',
                                        style: TextStyle(
                                          fontFamily: MyFonts.plusJakartaSans,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: MyColors.blackDark,
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  ),
                                  child: Text(
                                    'Map',
                                    style: TextStyle(
                                      fontFamily: MyFonts.plusJakartaSans,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: MyColors.blackDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          SizedBox(
                            height: 38.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              children: MapController.sportFilters.map((label) {
                                final selected = _mapController.selectedSportFilter == label;
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: FilterChip(
                                    label: Text(
                                      label,
                                      style: TextStyle(
                                        fontFamily: MyFonts.plusJakartaSans,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: selected ? MyColors.white : MyColors.blackDark,
                                      ),
                                    ),
                                    selected: selected,
                                    onSelected: (_) {
                                      setState(() {
                                        _mapController.applySportFilter(
                                          label,
                                          kExploreMockVenues,
                                          _onVenueFocused,
                                        );
                                      });
                                    },
                                    backgroundColor: MyColors.white,
                                    selectedColor: MyColors.brandPrimary,
                                    checkmarkColor: MyColors.white,
                                    side: BorderSide(
                                      color: selected ? MyColors.brandPrimary : MyColors.borderSubtle,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    showCheckmark: false,
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Divider(height: 1, thickness: 1, color: MyColors.borderSubtle),
                        ],
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
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h + bottomPad),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index.isOdd) {
                                return Divider(height: 1, color: MyColors.borderSubtle);
                              }
                              final v = venues[index ~/ 2];
                              return ExploreVenueSheetTile(
                                venue: v,
                                onTap: () => _onVenueFocused(v),
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
          Positioned(
            top: topPad + 8.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                _RoundIconButton(
                  icon: Icons.menu_rounded,
                  onPressed: () => Get.snackbar('Menu', 'Coming soon'),
                ),
                SizedBox(width: 10.w),
                Expanded(child: _SearchPill(onFilterTap: () {})),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundIconButton({required this.icon, required this.onPressed});

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
          child: Icon(icon, size: 22.sp, color: MyColors.blackDark),
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final VoidCallback onFilterTap;

  const _SearchPill({required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(28.r),
      child: InkWell(
        onTap: () => Get.snackbar('Search', 'Coming soon'),
        borderRadius: BorderRadius.circular(28.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 22.sp, color: MyColors.blackDark),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Search arenas, sports…',
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: MyColors.textSecondary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onFilterTap,
                child: Icon(Icons.tune_rounded, size: 22.sp, color: MyColors.blackDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
