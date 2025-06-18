import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class RecentEntryCard extends StatelessWidget {
  final VoidCallback onPressed;
  const RecentEntryCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.images.recentActivityBackgrocd.path),
          ),
        ),

        child: Row(
          children: [
            Space.w12,
            Container(
              alignment: Alignment.centerLeft,

              child: SvgPicture.asset(Assets.icons.amazingEmoji),
            ),
            Space.w20,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: HexColor('#FFEEF9'),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Amazing',
                      style: TextStyle(color: HexColor('#FC09A3')),
                    ),
                  ),
                  Space.h8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feb 2, 2025',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '02:22 AM',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '80 Words',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                  Space.h8,
                  Text('Feeling Amazing Today! 😊'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
