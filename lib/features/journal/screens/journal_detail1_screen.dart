import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';

import 'package:mindfulminis/gen/assets.gen.dart';

class JournalDetail1Screen extends StatefulWidget {
  static String routeName = 'journal-detail1-screen';
  static String routePath = '/journal-detail1-screen';

  const JournalDetail1Screen({super.key});

  @override
  State<JournalDetail1Screen> createState() => _JournalDetail1ScreenState();
}

class _JournalDetail1ScreenState extends State<JournalDetail1Screen> {
  @override
  bool _moveUp = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation after 800ms
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _moveUp = true;
      });
    });
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Positioned(
              child: SvgPicture.asset(Assets.images.journalBottomLeft),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(Assets.images.jouralBottomRight),
            ),

            // ✅ Fullscreen Animated Positioned
            AnimatedPositioned(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              bottom: _moveUp ? screenHeight * 0.8 : 0, // move it up
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  Assets.images.jouralDetailBottom,
                  height: 200, // Give it height so it’s visible
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Positioned(
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       SizedBox(height: 50),

//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomBackButton(hasBackground: true),
//                 SizedBox(width: 48),
//               ],
//             ),
//             Center(
//               child: Text(
//                 'Journal Details',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       Container(
//         alignment: Alignment.center,

//         child: SvgPicture.asset(Assets.icons.amazingEmoji),
//       ),
//       Space.h20,
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         decoration: BoxDecoration(
//           color: HexColor('#FFEEF9'),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Text(
//           'Amazing',
//           style: TextStyle(color: HexColor('#FC09A3')),
//         ),
//       ),
//       Space.h8,
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Feb 2, 2025',
//             style: TextStyle(fontSize: 12, color: Colors.black87),
//           ),
//           SizedBox(width: 8),
//           Text(
//             '•',
//             style: TextStyle(fontSize: 12, color: Colors.black87),
//           ),
//           SizedBox(width: 8),
//           Text(
//             '02:22 AM',
//             style: TextStyle(fontSize: 12, color: Colors.black87),
//           ),
//           SizedBox(width: 8),
//           Text(
//             '•',
//             style: TextStyle(fontSize: 12, color: Colors.black87),
//           ),
//           SizedBox(width: 8),
//           Text(
//             '80 Words',
//             style: TextStyle(fontSize: 12, color: Colors.black87),
//           ),
//         ],
//       ),
//       Space.h8,
//       Text('Feeling Amazing Today! 😊'),
//       Space.h20,

//       Divider(),
//       Space.h20,

//       Text(
//         'Today, I am grateful for the time I spent with my grandpa, listening to his stories and feeling his warmth. His wisdom and kindness made my day special. I plan to help set the table for dinner, read a new story, and smile more today. These little moments bring joy and mindfulness to my day. Every small action helps me feel happy and connected. 🌿✨',
//       ),
//     ],
//   ),
// ),

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
