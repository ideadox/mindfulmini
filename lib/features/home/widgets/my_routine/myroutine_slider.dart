import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../routine/models/routine_model.dart';
import '../../../routine/screens/routine_detail_screen.dart';
import '../../../routine/widgets/five_step_progressbar.dart';
import '../../providers/active_routine_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Ensure activity-based progress is loaded when the slider is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ActiveRoutineProvider>().refreshProgress();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use watch so the slider rebuilds when ActiveRoutineProvider notifies
    final provider = context.watch<ActiveRoutineProvider>();
    final routines = provider.routines;
    final progressMap = provider.routineProgress;

    // Bulletproof: if routines are loaded but progress hasn't been fetched yet,
    // trigger a fetch. The guard in _fetchTodayProgress prevents double-calls.
    if (routines.isNotEmpty && progressMap.isEmpty) {
      Future.microtask(() => provider.refreshProgress());
    }

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
              routines.map((i) {
                // Use activity-based progress when available
                final activityPct = progressMap[i.id];
                final pct =
                    activityPct ??
                    (i.durationDays > 0
                        ? ((i.dayNumberSinceStart() / i.durationDays) * 100)
                            .clamp(0, 100)
                            .round()
                        : 0);

                return Builder(
                  builder: (BuildContext context) {
                    return MyRoutineCard(
                      id: i.id,
                      routineModel: i,
                      linearGradient:
                          i.timeOfDay == 'morning'
                              ? LinearGradient(
                                colors: [
                                  HexColor('#FEFFCD').withValues(alpha: 0.3),
                                  HexColor('#E2C7FF').withValues(alpha: 0.5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                              : LinearGradient(
                                colors: [
                                  HexColor('#CDCEFF'),
                                  HexColor('#FCFAFF'),
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                      icon:
                          i.timeOfDay == 'morning'
                              ? Assets.icons.sunIcon
                              : Assets.icons.fullSunIcon,
                      title:
                          '${i.timeOfDay[0].toUpperCase()}${i.timeOfDay.substring(1)} Routine',
                      leftTask: i.goals.length,
                      percentComplete: pct,
                    );
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: routines.length,
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
  final String id;
  final RoutineModel? routineModel;

  const MyRoutineCard({
    super.key,
    required this.linearGradient,
    required this.icon,
    required this.title,
    required this.leftTask,
    required this.percentComplete,
    required this.id,
    this.routineModel,
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
                            onPressed: () async {
                              await sl<GoRouter>().pushNamed(
                                RoutineDetailScreen.routeName,
                                pathParameters: {'routineId': id},
                                extra: routineModel,
                              );
                              // Refresh progress when returning
                              if (context.mounted) {
                                context
                                    .read<ActiveRoutineProvider>()
                                    .refreshProgress();
                              }
                            },
                            child: Center(
                              child: Text(
                                'Get Started',
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
