import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/routine/widgets/horizontal_week_calender.dart';
import 'package:mindfulminis/features/routine/widgets/routine_level_container.dart';

class RoutineDetailScreen extends StatelessWidget {
  static String routeName = 'routine-detail-screen';
  static String routePath = '/routine-detail-screen';
  const RoutineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Space.h40,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomBackButton(hasBackground: true),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Morning Routine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        'Your program is ready!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // CircularProgressIndicator(value: 0.3),
                // CustomPrecentageIndicator(percent: 0.9),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Space.h20,
                  HorizontalWeekCalendar(
                    selectedDate: DateTime.now(),
                    onDateSelected: (date) {},
                  ),

                  Space.h20,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(),
                          //  ListView.builder(
                          //   shrinkWrap: true,
                          //   physics: NeverScrollableScrollPhysics(),
                          //   itemCount: 5,
                          //   itemBuilder: (context, index) {
                          //     return Column(
                          //       children: [
                          //         Container(
                          //           width: 10,
                          //           height: 10,
                          //           color: Colors.black,
                          //         ),

                          //         Container(
                          //           height: 108,
                          //           width: 10,
                          //           color: Colors.blue,
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            separatorBuilder: (context, index) => Space.h16,
                            itemBuilder: (context, index) {
                              return RoutineLevelContainer(
                                isCompleted: index == 0,
                                currentLevel: index == 1,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.6);
    path.quadraticBezierTo(size.width / 2, size.height, 0, size.height * 0.6);
    path.quadraticBezierTo(0, 0, size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LocationPinPainter extends CustomPainter {
  final bool isActive;
  final Color color;

  LocationPinPainter({required this.isActive, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, 0); // Top center
    path.cubicTo(
      width,
      height * 0.25, // right control point
      width * 0.85,
      height * 0.75, // right bottom curve
      width / 2,
      height, // bottom point
    );
    path.cubicTo(
      width * 0.15,
      height * 0.75, // left bottom curve
      0,
      height * 0.25, // left control point
      width / 2,
      0, // back to top center
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
