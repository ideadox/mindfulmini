import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

/// Translucent pill with timer icon + duration text (home collection cards).
class CollectionCardDurationBadge extends StatelessWidget {
  final String label;

  const CollectionCardDurationBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final gray = const Color(0xFF30303D).withValues(alpha: 0.8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: gray),
          Space.w4,
          Text(
            label,
            style: TextStyle(
              color: gray,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
