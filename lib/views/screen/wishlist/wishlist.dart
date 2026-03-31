import 'package:flutter/material.dart';

import '../../widgets/coming_soon_placeholder.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ComingSoonPlaceholder(
        title: 'Wishlists',
        icon: Icons.favorite_border_rounded,
        message:
            'Save venues you love and plan your next game — this space is on the way.',
      ),
    );
  }
}
