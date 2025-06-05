import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../routine/screens/my_routine_screen.dart';
import '../../../routine/widgets/five_step_progressbar.dart';

class RoutineCardDataModel {
  final String icon, title;
  final int leftTask, percentComplete;
  final LinearGradient linearGradient;

  RoutineCardDataModel({
    required this.icon,
    required this.title,
    required this.leftTask,
    required this.percentComplete,
    required this.linearGradient,
  });
}

class MyroutineSlider extends StatefulWidget {
  const MyroutineSlider({super.key});

  @override
  State<MyroutineSlider> createState() => _MyroutineSliderState();
}

class _MyroutineSliderState extends State<MyroutineSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  final List<RoutineCardDataModel> items = [
    RoutineCardDataModel(
      icon: Assets.icons.sunIcon,
      title: 'Morning Routine',
      leftTask: 5,
      percentComplete: 20,
      linearGradient: LinearGradient(
        colors: [HexColor('#CDCEFF'), HexColor('#FCFAFF')],

        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    RoutineCardDataModel(
      icon: Assets.icons.fullSunIcon,
      title: 'Afternoon Routine',
      leftTask: 2,
      percentComplete: 50,
      linearGradient: LinearGradient(
        colors: [
          HexColor('#FEFFCD').withValues(alpha: 0.3),
          HexColor('#E2C7FF').withValues(alpha: 0.5),
        ],

        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            aspectRatio: 15 / 4,
            viewportFraction: 1,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items:
              items.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return MyRoutineCard(
                      linearGradient: i.linearGradient,
                      icon: i.icon,
                      title: i.title,
                      leftTask: i.leftTask,
                      percentComplete: i.percentComplete,
                    );
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: items.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: Colors.black,
            dotColor: Colors.grey,
            dotHeight: 6,
            dotWidth: 8,
          ),
          onDotClicked: (index) {
            _carouselController.animateToPage(index);
          },
        ),
      ],
    );
  }
}

class MyRoutineCard extends StatelessWidget {
  final LinearGradient linearGradient;
  final String icon, title;
  final int leftTask;
  final int percentComplete;

  const MyRoutineCard({
    super.key,
    required this.linearGradient,
    required this.icon,
    required this.title,
    required this.leftTask,
    required this.percentComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        gradient: linearGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset(Assets.vectors.myroutineRightPng.path),
          ),
          Positioned(
            bottom: -70,
            child: SvgPicture.asset(Assets.vectors.myroutineCenter),
          ),

          Positioned(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 12,
                top: 15,
                bottom: 15,
              ),
              child: Row(
                children: [
                  Column(children: [SvgPicture.asset(icon)]),
                  Space.w8,
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(children: [Text(title)]),
                        Space.h4,

                        Row(
                          children: [
                            Text(
                              '$leftTask Task Left',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: FiveStepProgressBar(
                                  percentComplete: percentComplete.toDouble(),
                                  height: 8,
                                ),
                              ),
                              Space.w8,

                              Text('$percentComplete%'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Space.w8,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 42,
                          child: GradientButton(
                            onPressed: () {
                              sl<GoRouter>().pushNamed(
                                MyRoutineScreen.routeName,
                              );
                            },
                            child: Center(
                              child: Text(
                                'Go to Routine',
                                style: AppTextTheme.mainButtonTextStyle(
                                  context,
                                ).titleLarge?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
