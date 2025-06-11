import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class NotificationCard extends StatelessWidget {
  final int index;
  const NotificationCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: index == 0 ? null : Border.all(color: Colors.grey.shade200),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              index == 0
                  ? [
                    HexColor('#FF98A3').withValues(alpha: 0.08),
                    HexColor('#FF98A3').withValues(alpha: 0.15),
                  ]
                  : [
                    const Color.fromARGB(255, 250, 244, 255),
                    HexColor('#EDEFFF').withValues(alpha: 0.5),
                  ],
        ),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(Assets.icons.notificationCardIcon.path),
        ),
        title: Text(
          'Relax and Reset!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'A new Mini Body Scan is ready for you! Let’s take a mindful moment together.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        trailing: Text(
          '2m ago',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
