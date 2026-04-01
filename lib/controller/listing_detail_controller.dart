/*
  Listing detail — carousel index, favorites, mock reviews metadata.
  Navigation to gallery / fullscreen / sheets is performed by listing UI widgets.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/explore_venue.dart';
import '../data/models/listing_review.dart';

class ListingDetailController extends GetxController {
  ListingDetailController({required this.venue});

  final ExploreVenue venue;

  late final PageController carouselPageController;
  final RxInt carouselIndex = 0.obs;
  final RxBool isFavorite = false.obs;

  List<String> get photoUrls => venue.orderedPhotoUrls;

  /// Star row percentages (5 → 1), for reviews UI.
  late final Map<int, double> starDistributionPercent;

  late final List<ListingReview> reviews;

  @override
  void onInit() {
    super.onInit();
    carouselPageController = PageController();
    starDistributionPercent = {5: 7, 4: 4, 3: 0, 2: 0, 1: 0};
    reviews = _defaultReviews();
  }

  @override
  void onClose() {
    carouselPageController.dispose();
    super.onClose();
  }

  void onCarouselPageChanged(int index) {
    carouselIndex.value = index;
  }

  void toggleFavorite() => isFavorite.toggle();

  List<ListingReview> _defaultReviews() {
    return const [
      ListingReview(
        authorName: 'Anonymous Player',
        dateLabel: 'March 2026',
        rating: 5,
        body:
            'Excellent lighting for evening sessions. Came with 10 friends and we all had a blast.',
      ),
      ListingReview(
        authorName: 'Sara K.',
        dateLabel: 'February 2026',
        rating: 4.5,
        body: 'Courts were spotless. Booking process was smooth.',
      ),
      ListingReview(
        authorName: 'Hassan M.',
        dateLabel: 'January 2026',
        rating: 5,
        body: 'Coaches were professional — great for beginners.',
      ),
    ];
  }
}
