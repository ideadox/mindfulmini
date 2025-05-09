import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ActivityHomeCard extends StatelessWidget {
  final String image;
  const ActivityHomeCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
        ),
      ),
    );
  }
}
