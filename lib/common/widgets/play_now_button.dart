import 'package:flutter/material.dart';

class PlayNowButton extends StatelessWidget {
  const PlayNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.all(0),
        maximumSize: Size(216 * 0.45, 28),
        minimumSize: Size(216 * 0.45, 28),
        foregroundColor: Colors.black,
      ),
      child: Text('Play Now', style: TextStyle(fontSize: 12)),
    );
  }
}
