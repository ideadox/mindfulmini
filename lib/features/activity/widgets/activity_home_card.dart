import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ActivityHomeCard extends StatelessWidget {
  final String image;
  final VoidCallback? onTap;
  const ActivityHomeCard({super.key, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
        ),
      ),
    );
  }
}
