import 'package:flutter/material.dart';

class VideoProgressBar extends StatelessWidget {
  final double progress; // Value from 0.0 to 1.0

  const VideoProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            height: 5,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),

          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                gradient: const LinearGradient(
                  colors: [Color(0xFF6E40F9), Color(0xFFCE89FF)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
