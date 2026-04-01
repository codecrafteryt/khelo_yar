/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: April 1, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Edge-to-edge floating top header for explore search (WHERE / DATE / SPORT).
  Matches [HomeExploreScreen] search strip: full width, shadow, bottom radius only;
  map + listing stay visible below (opened with a scrim in the parent Stack).
*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khelo_yar/utils/extensions/extentions.dart';
import 'package:khelo_yar/utils/values/style.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';
import '../../utils/values/my_images.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';

/// Bottom corner radius — aligns with listing sheet top radius (~20).
const double _kSearchPanelBottomRadius = 20;

class ExploreSearchFullSheet extends StatefulWidget {
  const ExploreSearchFullSheet({
    super.key,
    required this.onClose,
    required this.whereDisplayText,
    required this.dateDisplayText,
    required this.onWhereTap,
    required this.onDateTap,
    required this.sportDisplayText,
    required this.onSportTap,
    required this.onSearchPressed,
  });

  final VoidCallback onClose;
  final String whereDisplayText;
  final String dateDisplayText;
  final String sportDisplayText;
  final VoidCallback onWhereTap;
  final VoidCallback onDateTap;
  final VoidCallback onSportTap;
  final VoidCallback onSearchPressed;

  @override
  State<ExploreSearchFullSheet> createState() => _ExploreSearchFullSheetState();
}

class _ExploreSearchFullSheetState extends State<ExploreSearchFullSheet> {
  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);
  static const _defaultBorder = Color.fromRGBO(145, 148, 155, 1);
  static const _hintColor = Color.fromRGBO(211, 211, 211, 1);

  late final TextEditingController _whereController;
  late final TextEditingController _dateController;
  late final TextEditingController _sportController;

  @override
  void initState() {
    super.initState();
    _whereController = TextEditingController(text: widget.whereDisplayText);
    _dateController = TextEditingController(text: widget.dateDisplayText);
    _sportController = TextEditingController(text: widget.sportDisplayText);
  }

  @override
  void didUpdateWidget(covariant ExploreSearchFullSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.whereDisplayText != widget.whereDisplayText &&
        widget.whereDisplayText != _whereController.text) {
      _whereController.text = widget.whereDisplayText;
    }
    if (oldWidget.dateDisplayText != widget.dateDisplayText &&
        widget.dateDisplayText != _dateController.text) {
      _dateController.text = widget.dateDisplayText;
    }
    if (oldWidget.sportDisplayText != widget.sportDisplayText &&
        widget.sportDisplayText != _sportController.text) {
      _sportController.text = widget.sportDisplayText;
    }
  }

  @override
  void dispose() {
    _whereController.dispose();
    _dateController.dispose();
    _sportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    final bottomRadius = BorderRadius.only(
      bottomLeft: Radius.circular(_kSearchPanelBottomRadius.r),
      bottomRight: Radius.circular(_kSearchPanelBottomRadius.r),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: bottomRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: bottomRadius,
        child: ColoredBox(
          color: MyColors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, topInset + 8.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: SvgPicture.asset(
                      MyImages.backSvg,
                      width: 22.w,
                      height: 22.w,
                      colorFilter: const ColorFilter.mode(MyColors.black, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Column(
                  children: [
                    CustomTextField(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      readOnly: true,
                      labelText: 'Where',
                      hintText: 'Where would you like to go',
                      controller: _whereController,
                      onTap: widget.onWhereTap,
                      keyboardType: TextInputType.streetAddress,
                      borderRadius: 12.r,
                      padding: EdgeInsets.zero,
                      borderColor: _defaultBorder,
                      focusedBorderColor: Colors.black,
                      enabledBorderWidth: 0.5,
                      focusedBorderWidth: 1,
                      errorBorderColor: _errorColor,
                      errorBorderWidth: 1,
                      focusedErrorBorderWidth: 1,
                      hintColor: _hintColor,
                      textColor: Colors.black,
                      cursorColor: Colors.black,
                      fillColor: Colors.transparent,
                      focusedFillColor: Colors.transparent,
                      fontSize: 14.sp,
                      hintFontWeight: FontWeight.w400,
                      labelColor: Colors.black,
                      floatingLabelStyle: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    25.sbh,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            readOnly: true,
                            labelText: 'Date',
                            hintText: 'Any Date',
                            controller: _dateController,
                            onTap: widget.onDateTap,
                            keyboardType: TextInputType.text,
                            borderRadius: 12.r,
                            padding: EdgeInsets.zero,
                            borderColor: _defaultBorder,
                            focusedBorderColor: Colors.black,
                            enabledBorderWidth: 0.5,
                            focusedBorderWidth: 1,
                            errorBorderColor: _errorColor,
                            errorBorderWidth: 1,
                            focusedErrorBorderWidth: 1,
                            hintColor: _hintColor,
                            textColor: Colors.black,
                            cursorColor: Colors.black,
                            fillColor: Colors.transparent,
                            focusedFillColor: Colors.transparent,
                            fontSize: 14.sp,
                            hintFontWeight: FontWeight.w400,
                            labelColor: Colors.black,
                            floatingLabelStyle: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        10.sbw,
                        Expanded(
                          child: CustomTextField(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            readOnly: true,
                            labelText: 'Sport',
                            hintText: 'Any sport',
                            controller: _sportController,
                            onTap: widget.onSportTap,
                            keyboardType: TextInputType.text,
                            borderRadius: 12.r,
                            padding: EdgeInsets.zero,
                            borderColor: _defaultBorder,
                            focusedBorderColor: Colors.black,
                            enabledBorderWidth: 0.5,
                            focusedBorderWidth: 1,
                            errorBorderColor: _errorColor,
                            errorBorderWidth: 1,
                            focusedErrorBorderWidth: 1,
                            hintColor: _hintColor,
                            textColor: Colors.black,
                            cursorColor: Colors.black,
                            fillColor: Colors.transparent,
                            focusedFillColor: Colors.transparent,
                            fontSize: 14.sp,
                            hintFontWeight: FontWeight.w400,
                            labelColor: Colors.black,
                            floatingLabelStyle: TextStyle(
                              fontFamily: MyFonts.plusJakartaSans,
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                20.sbh,
                Row(
                  children: [
                    TextButton(
                      onPressed: widget.onClose,
                      child: Text(
                        'Cancel',
                        style: kSize15DarkW500Text,
                      ),
                    ),
                    150.sbw,
                    Expanded(
                      child: CustomButton(
                        text: 'Search',
                        onPressed: () {
                          widget.onSearchPressed();
                        },
                        svgIconPath: MyImages.searchSvg,
                        iconColor: Colors.white,
                        width: double.infinity,
                        borderRadius: 12.r,
                        backgroundColor: MyColors.brandPrimary,
                        borderColor: MyColors.brandPrimary,
                        textColor: MyColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
