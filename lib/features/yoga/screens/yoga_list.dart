import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/play%20visuals/screen/play_visuals.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class YogaList extends StatelessWidget {
  static String routeName = 'yoga-list';
  static String routePath = '/yoga-list';

  const YogaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space.h32,
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        sl<GoRouter>().pop();
                      },
                      icon: Image.asset(Assets.icons.chevron.path),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                Center(
                  child: Text('Morning yoga', style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spring Yoga',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Space.h8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gentle Stretches to Start Your Day',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        'Total 10 min',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Space.h20,
                  VerticalStepperList(),
                  Space.h40,
                  Space.h40,
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GradientButton(
          onPressed: () {
            sl<GoRouter>().pushNamed(PlayVisuals.routeName);
          },
          child: Center(
            child: Text(
              'Let’s Go',
              style: AppTextTheme.mainButtonTextStyle(context).titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalStepperList extends StatelessWidget {
  const VerticalStepperList({super.key});

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 170;
    const double stepperWidth = 30;
    const int stepCount = 4;
    const int activeIndex = 1;

    return ListView.builder(
      itemCount: stepCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final isLast = index == stepCount - 1;
        final bool isActive = index <= activeIndex;
        return SizedBox(
          height: cardHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stepper line and dot
              SizedBox(
                width: stepperWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Stepper line
                    Positioned.fill(
                      top: isFirst ? cardHeight / 2 + 9 : 0,
                      bottom: isLast ? cardHeight / 2 + 9 : 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 4,
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? LinearGradient(
                                    colors: [
                                      HexColor(
                                        '#6E40F9',
                                      ).withValues(alpha: 0.8),
                                      HexColor(
                                        '#A569FB',
                                      ).withValues(alpha: 0.8),
                                      HexColor(
                                        '#CE89FF',
                                      ).withValues(alpha: 0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: isActive ? null : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // Stepper Dot
                    Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: activeIndex == index
                            ? SvgPicture.asset(
                                Assets.icons.currentLevelIcon,
                              )
                            : index < activeIndex
                                ? SvgPicture.asset(
                                    Assets.icons.completedLevelIcon,
                                  )
                                : SvgPicture.asset(
                                    Assets.icons.upcomingLevelIcon,
                                  ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Card content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(Assets.dummy.springYoga.path),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
