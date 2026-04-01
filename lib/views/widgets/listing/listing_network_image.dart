/*
  Cached network image + shimmer placeholder + error fallback (listing photos).
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/values/my_color.dart';

class ListingNetworkImage extends StatelessWidget {
  const ListingNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => _ShimmerBox(width: width, height: height),
      errorWidget: (context, url, error) => _ErrorBox(width: width, height: height),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.darkWhite,
      highlightColor: MyColors.white,
      child: Container(
        width: width,
        height: height,
        color: MyColors.darkWhite,
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: MyColors.darkWhite,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined, size: 40.sp, color: MyColors.grayscale30),
    );
  }
}
