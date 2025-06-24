import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail1_screen.dart';

import 'package:mindfulminis/gen/assets.gen.dart';

class JournalDetailScreen extends StatefulWidget {
  static String routeName = 'journal-detail-screen';
  static String routePath = '/journal-detail-screen';

  const JournalDetailScreen({super.key});

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.jouralDetailBottom),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,

              child: SvgPicture.asset(Assets.icons.amazingEmoji),
            ),
            Space.h20,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

PageRouteBuilder _createSpringRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack, // Mimics spring-like effect
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );
}
