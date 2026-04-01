/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: Navigation Bar — Explore sheet extent can hide bar on map-first view.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khelo_yar/controller/home_host_controller.dart';
import 'dart:convert';
import 'dart:io';
import 'package:khelo_yar/views/screen/bookings/booking.dart';
import 'package:khelo_yar/views/screen/chat/chats.dart';
import '../../../utils/values/my_color.dart';
import '../account/account.dart';
import '../wishlist/wishlist.dart';
import 'home_explore_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> _children = const [
    HomeExploreScreen(),
    Wishlist(),
    Booking(),
    Chats(),
    Account(),
  ];

  int _selectedIndex = 0;

  void _debugLog(String hypothesisId, String message, Map<String, dynamic> data) {
    final payload = <String, dynamic>{
      'sessionId': 'a4c2a6',
      'runId': 'post-fix',
      'hypothesisId': hypothesisId,
      'location': 'bottom_nav_bar.dart',
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    File('/Users/chsalman/Desktop/khelo_yar/.cursor/debug-a4c2a6.log')
        .writeAsStringSync('${jsonEncode(payload)}\n', mode: FileMode.append);
  }

  void _onItemTapped(int index) {
    // #region agent log
    _debugLog('H6', 'NavBar.onItemTapped before setState', {
      'stateHash': identityHashCode(this),
      'fromIndex': _selectedIndex,
      'toIndex': index,
    });
    // #endregion
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // #region agent log
    _debugLog('H1', 'NavBar.build', {
      'stateHash': identityHashCode(this),
      'selectedIndex': _selectedIndex,
      'childrenLen': _children.length,
    });
    // #endregion
    final hc = Get.find<HomeHostController>();
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _children,
      ),
      bottomNavigationBar: ValueListenableBuilder<double>(
        valueListenable: hc.sheetExtentNotifier,
        builder: (context, extent, _) {
          // Explore: hide bottom nav when sheet is very collapsed (extent < 0.15).
          final show = _selectedIndex != 0 ||
              extent >= HomeHostController.extentShowBottomNav;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: show ? 60.0 : 0.0,
            child: Wrap(
              spacing: 20,
              children: [
                BottomNavigationBar(
                  backgroundColor: MyColors.background,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onItemTapped,
                  currentIndex: _selectedIndex,
                  selectedItemColor: MyColors.brandPrimary,
                  unselectedItemColor: const Color.fromRGBO(120, 130, 138, 1),
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.explore_outlined, size: 20.0),
                      label: 'Explore'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.favorite_border, size: 20.0),
                      label: 'Wishlist'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.calendar_month_sharp, size: 20.0),
                      label: 'Booking'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.chat_outlined, size: 20.0),
                      label: 'Inbox'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.account_circle_outlined, size: 20.0),
                      label: 'Account'.tr,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
