/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: Navigation Bar and some logic.
*/
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../../utils/values/my_color.dart';
import '../account/account.dart';
import '../wishlist/wishlist.dart';
import 'home_explore_screen.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBarState();
}


class _NavBarState extends State<NavBar> {
  final List<Widget> _children = [
    const HomeExploreScreen(),
    Wishlist(),
    Account(),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  int _selectedIndex = 0;
  late ScrollController _scrollController;
  bool _isNavBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isNavBarVisible = false; // Hide the bottom nav bar
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isNavBarVisible = true; // Show the bottom nav bar
        });
      }
    });
  }

  _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is UserScrollNotification) {
            if (scrollNotification.direction == ScrollDirection.reverse) {
              setState(() => _isNavBarVisible = false); // Hiding Nav Bar
            } else if (scrollNotification.direction ==
                ScrollDirection.forward) {
              setState(() => _isNavBarVisible = true); // Showing Nav Bar
            }
          }
          return true;
        },
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _isNavBarVisible
            ? 60.0
            : 0.0, // Adjust the height to show/hide the bar
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
                BottomNavigationBarItem(icon: const Icon(Icons.explore_outlined, size: 20.0,), label: 'Explore'.tr),
                BottomNavigationBarItem(icon: const Icon(Icons.favorite_border, size: 20.0,), label: 'Wishlist'.tr),
                BottomNavigationBarItem(icon: const Icon(Icons.account_circle_outlined, size: 20.0,), label: 'Account'.tr),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
