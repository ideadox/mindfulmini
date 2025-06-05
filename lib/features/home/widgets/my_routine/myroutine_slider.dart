import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../routine/screens/my_routine_screen.dart';
import '../../../routine/widgets/five_step_progressbar.dart';

class MyroutineSlider extends StatefulWidget {
  const MyroutineSlider({super.key});

  @override
  State<MyroutineSlider> createState() => _MyroutineSliderState();
}

class _MyroutineSliderState extends State<MyroutineSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  final List<int> items = [1, 2];

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
                      gradientColor: [],
                      icon: '',
                      title: '',
                      leftTask: 5,
                      percentComplete: 20,
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
  final List<Color> gradientColor;
  final String icon, title;
  final int leftTask;
  final int percentComplete;

  const MyRoutineCard({
    super.key,
    required this.gradientColor,
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
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [HexColor('#CDCEFF'), HexColor('#FCFAFF')],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                  Column(children: [SvgPicture.asset(Assets.icons.sunIcon)]),
                  Space.w8,
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(children: [Text('Morning Routine')]),
                        Space.h4,

                        Row(
                          children: [
                            Text(
                              '5 Task Left',
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
                                  percentComplete: 20,
                                  height: 8,
                                ),
                              ),
                              Space.w8,

                              Text('20%'),
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


              //  Column(
              //   children: [
              //     Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         SvgPicture.asset(Assets.icons.sunIcon),
              //         Space.w8,
              //         Text('Morning Routine'),
              //       ],
              //     ),
              //     Space.h12,
              //     Row(
              //       children: [
              //         Expanded(
              //           flex: 2,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 '7-Day Kickstart',
              //                 style: TextStyle(
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.w600,
              //                   color: HexColor('#47454D'),
              //                 ),
              //               ),
              //               Space.h16,
              //               Row(
              //                 children: [
              //                   Container(
              //                     padding: EdgeInsets.symmetric(
              //                       horizontal: 10,
              //                       vertical: 2,
              //                     ),
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(30),
              //                       color: AppColors.purple.withOpacity(0.4),
              //                     ),
              //                     child: Row(
              //                       children: [
              //                         CustomGradientText(text: '3'),
              //                         Space.w4,
              //                         Text('Task'),
              //                         Space.w4,
              //                         SizedBox(
              //                           height: 18,
              //                           child: VerticalDivider(
              //                             thickness: 1,
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                         CustomGradientText(text: '40'),
              //                         Space.w4,
              //                         Text('Min'),
              //                       ],
              //                     ),
              //                   ),
              //                   Space.w16,
              //                   Text(
              //                     "Day 1",
              //                     style: TextStyle(fontWeight: FontWeight.w600),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //         Expanded(
              //           flex: 1,
              //           child: Builder(
              //             builder: (context) {
              //               if (formHome) {
              //                 return SizedBox(
              //                   height: 42,
              //                   child: GradientButton(
              //                     onPressed: () {
              //                       sl<GoRouter>().pushNamed(
              //                         MyRoutineScreen.routeName,
              //                       );
              //                     },
              //                     child: Center(
              //                       child: Text(
              //                         'Go to routine',
              //                         style: AppTextTheme.mainButtonTextStyle(
              //                           context,
              //                         ).titleLarge?.copyWith(fontSize: 12),
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               }
              //               return Container(
              //                 alignment: Alignment.center,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(30),

              //                   gradient: AppColors.primaryGradient,
              //                 ),
              //                 child: Container(
              //                   height: 42,

              //                   alignment: Alignment.center,
              //                   margin: EdgeInsets.all(1),
              //                   decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(30),
              //                   ),
              //                   child: Text(
              //                     'Go To Routine',
              //                     style: TextStyle(fontSize: 12),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //     Space.h16,
              //     Row(
              //       children: [
              //         Expanded(child: FiveStepProgressBar(percentComplete: 20)),
              //         Space.w20,
              //         Text('10%'),
              //         Expanded(child: Container()),
              //       ],
              //     ),
              //   ],
              // ),