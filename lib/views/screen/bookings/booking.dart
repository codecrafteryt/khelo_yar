/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: bookings
*/

import 'package:flutter/material.dart';

import '../../widgets/coming_soon_placeholder.dart';

class Booking extends StatelessWidget {
  const Booking({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ComingSoonPlaceholder(
        title: 'Bookings',
        icon: Icons.calendar_month_rounded,
        message:
            'Your upcoming sessions and history will appear here soon.',
      ),
    );
  }
}
