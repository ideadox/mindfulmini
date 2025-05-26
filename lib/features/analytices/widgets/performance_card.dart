import 'package:flutter/material.dart';

class PerformanceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const PerformanceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title), Text(subtitle)],
      ),
    );
  }
}
