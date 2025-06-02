import 'package:flutter/material.dart';

class OverallInfo extends StatelessWidget {
  const OverallInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Fully Completed days: ',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text('12/30', style: TextStyle(fontSize: 12)),
            Spacer(),
            Text(
              'Spent: ',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text('13h 30 min', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
