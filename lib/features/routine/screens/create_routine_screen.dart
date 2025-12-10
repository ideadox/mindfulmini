import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/routine/providers/create_routine_provider.dart';
import 'package:mindfulminis/features/routine/widgets/create_routine_conatiner.dart';
import 'package:mindfulminis/features/routine/widgets/goal_routine_container.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/utiles/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/scroll_timepicker.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/remainder_routine_provider.dart';
import '../providers/routine_provider.dart';
import '../widgets/create_week_days.dart';

class CreateRoutineScreen extends StatefulWidget {
  static String routeName = 'create-route-screen';
  static String routePath = '/create-route-screen';

  const CreateRoutineScreen({super.key});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  final int totalSteps = 5;

  void _onPageChanged(int index) {
    setState(() {
      currentStep = index;
    });
  }

  void _goToStep(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 32 : 12,
          decoration: BoxDecoration(
            gradient:
                currentStep == 4
                    ? LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        HexColor('#6E40F9'),
                        HexColor('#A569FB'),
                        HexColor('#CE89FF'),
                      ],
                    )
                    : !isActive
                    ? null
                    : LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        HexColor('#6E40F9'),
                        HexColor('#A569FB'),
                        HexColor('#CE89FF'),
                      ],
                    ),
            color: isActive ? null : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileId = context.read<ProfileProvider>().userProfile.id;
    return GradientScaffold(
      hasGradient: currentStep != 4,
      body: ChangeNotifierProvider(
        create: (context) => CreateRoutineProvider(profileId),
        child: Consumer<CreateRoutineProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Space.h8,
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    alignment: Alignment.center,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          CustomBackButton(hasBackground: true),
                          SizedBox(width: 48),
                        ],
                      ),

                      Center(child: _buildStepper()),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: _onPageChanged,
                    children: [
                      BuildFirstPage(provider: provider),
                      BuildSecondPage(provider: provider),
                      BuildThirdPage(provider: provider),
                      BuildFourthPage(provider: provider),
                      BuildFifthPage(provider: provider),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Builder(
                    builder: (context) {
                      if (currentStep == 0) {
                        return GradientButton(
                          onPressed:
                              provider.durationDays == null
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              'Continue',
                              style:
                                  provider.durationDays == null
                                      ? null
                                      : AppTextTheme.mainButtonTextStyle(
                                        context,
                                      ).titleLarge,
                            ),
                          ),
                        );
                      }
                      if (currentStep == 1) {
                        return GradientButton(
                          onPressed:
                              provider.timeOfDay == null
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              'Continue',
                              style:
                                  provider.timeOfDay == null
                                      ? null
                                      : AppTextTheme.mainButtonTextStyle(
                                        context,
                                      ).titleLarge,
                            ),
                          ),
                        );
                      }
                      if (currentStep == 2) {
                        return GradientButton(
                          onPressed:
                              provider.dailyDurationMinutes == null
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              'Continue',
                              style:
                                  provider.dailyDurationMinutes == null
                                      ? null
                                      : AppTextTheme.mainButtonTextStyle(
                                        context,
                                      ).titleLarge,
                            ),
                          ),
                        );
                      }

                      if (currentStep == 3) {
                        return GradientButton(
                          onPressed:
                              provider.goals.length < 3
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              provider.goals.length < 3
                                  ? 'Select ${3 - provider.goals.length} More Activities'
                                  : 'Continue',
                              style:
                                  provider.goals.length < 3
                                      ? null
                                      : AppTextTheme.mainButtonTextStyle(
                                        context,
                                      ).titleLarge,
                            ),
                          ),
                        );
                      }

                      if (currentStep == 4) {
                        return GradientButton(
                          onPressed:
                              provider.creating
                                  ? null
                                  : () async {
                                    try {
                                      await provider.createRoutine();
                                    } catch (e) {
                                      if (context.mounted) {
                                        CustomSnackbar.showSnackBar(
                                          context,
                                          Text(e.toString()),
                                        );
                                      }
                                    }
                                  },
                          child: Center(
                            child:
                                provider.creating
                                    ? CircularProgressIndicator()
                                    : Text(
                                      'Continue',
                                      style:
                                          AppTextTheme.mainButtonTextStyle(
                                            context,
                                          ).titleLarge,
                                    ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BuildFirstPage extends StatelessWidget {
  final CreateRoutineProvider provider;
  const BuildFirstPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Text(
              textAlign: TextAlign.center,
              'How many days do you\nlike to do this routine?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h32,

            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.firstPageData.length,
              separatorBuilder: (context, index) => Space.h12,
              itemBuilder: (context, index) {
                final item = provider.firstPageData[index];
                return CreateRoutineConatiner(
                  icon: item['icon'] ?? '',
                  title: item['title'] ?? '',
                  subtitle: item['subtitle'] ?? '',
                  radioValue: item['duration'] ?? "",
                  groupValue: provider.durationDays ?? "",
                  onChanged: (p0) {
                    provider.onChangeTimeLine(p0);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BuildSecondPage extends StatelessWidget {
  final CreateRoutineProvider provider;

  const BuildSecondPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              textAlign: TextAlign.center,
              'What time of the day do you prefer?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h32,

            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.secondPageData.length,
              separatorBuilder: (context, index) => Space.h12,
              itemBuilder: (context, index) {
                final item = provider.secondPageData[index];
                return CreateRoutineConatiner(
                  icon: item['icon'] ?? '',
                  title: item['title'] ?? '',
                  subtitle: item['subtitle'] ?? '',
                  radioValue: item['subtitle'] ?? "",
                  groupValue: provider.timeOfDay ?? "",
                  onChanged: (p0) {
                    provider.onChangeTime(p0);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BuildThirdPage extends StatelessWidget {
  final CreateRoutineProvider provider;

  const BuildThirdPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              textAlign: TextAlign.center,
              'How much time do you like to invest every day?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h32,

            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.thirdPageData.length,
              separatorBuilder: (context, index) => Space.h12,
              itemBuilder: (context, index) {
                final item = provider.thirdPageData[index];
                return CreateRoutineConatiner(
                  icon: item['icon'] ?? '',
                  title: item['title'] ?? '',
                  subtitle: item['subtitle'] ?? '',
                  radioValue: item['time'].toString(),
                  groupValue: provider.dailyDurationMinutes ?? "",
                  onChanged: (p0) {
                    provider.onChangeSpendTime(p0);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BuildFourthPage extends StatelessWidget {
  final CreateRoutineProvider provider;

  const BuildFourthPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text(
            textAlign: TextAlign.center,
            'What goals you want to\nfocus on?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Space.h32,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                log(constraints.maxHeight.toString());

                double vertSpace = 12.0;

                double cardHeight = constraints.maxHeight / 3 - (vertSpace);
                double totalCardWith = 2 * cardHeight + vertSpace;
                double padding = constraints.maxWidth - totalCardWith;

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        left: padding / 2,
                        right: padding / 2,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        mainAxisExtent: cardHeight,
                      ),
                      itemCount:
                          provider.fourthPageData.length.isEven
                              ? provider.fourthPageData.length
                              : provider.fourthPageData.length - 1,
                      itemBuilder: (context, index) {
                        final item = provider.fourthPageData[index];

                        return GoalRoutineContainer(
                          title: item['title'] ?? "",
                          icon: item['icon'] ?? '',
                          isSelected: provider.goals.contains(item['title']),
                          onChanged: (val) {
                            provider.onChangeType(item['title']);
                          },
                        );
                      },
                    ),
                    Space.h12,
                    if (provider.fourthPageData.length.isOdd)
                      SizedBox(
                        height: cardHeight,
                        width: cardHeight,
                        child: GoalRoutineContainer(
                          title:
                              provider.fourthPageData[provider
                                      .fourthPageData
                                      .length -
                                  1]['title'] ??
                              "",
                          icon:
                              provider.fourthPageData[provider
                                      .fourthPageData
                                      .length -
                                  1]['icon'] ??
                              '',
                          isSelected: provider.goals.contains(
                            provider.fourthPageData[provider
                                    .fourthPageData
                                    .length -
                                1]['title'],
                          ),
                          onChanged: (val) {
                            provider.onChangeType(
                              provider.fourthPageData[provider
                                      .fourthPageData
                                      .length -
                                  1]['title'],
                            );
                          },
                        ),
                      ),
                  ],
                );

                // Column(
                //   children: [
                //     Row(
                //       children: [
                //         SizedBox(
                //           height: cardHeight,
                //           width: cardHeight,
                //           child: GoalRoutineContainer(
                //             title:
                //                 provider.fourthPageData[provider
                //                         .fourthPageData
                //                         .length -
                //                     1]['title'] ??
                //                 "",
                //             icon:
                //                 provider.fourthPageData[provider
                //                         .fourthPageData
                //                         .length -
                //                     1]['icon'] ??
                //                 '',
                //             isSelected: provider.routineTypes.contains(
                //               provider.fourthPageData[provider
                //                       .fourthPageData
                //                       .length -
                //                   1]['title'],
                //             ),
                //             onChanged: (val) {
                //               provider.onChangeType(
                //                 provider.fourthPageData[provider
                //                         .fourthPageData
                //                         .length -
                //                     1]['title'],
                //               );
                //             },
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BuildFifthPage extends StatelessWidget {
  final CreateRoutineProvider provider;
  const BuildFifthPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RemainderRoutineProvider(),
      child: Consumer<RemainderRoutineProvider>(
        builder: (context, rProvider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rProvider.remainder)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remind me at ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomGradientText(
                        text: AppFormate.formatAMPM(rProvider.selectedTime!),
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                if (!rProvider.remainder)
                  Text(
                    'No Reminder',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                Space.h20,
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,

                      colors: [HexColor('#F4F0FF'), HexColor('#FFFFFF')],
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(right: 12, top: 12),
                    leading: SvgPicture.asset(Assets.icons.rimderIcon),
                    horizontalTitleGap: 0,
                    title: Text(
                      'Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Set a specific time to remind me',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey45,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppColors.purple,
                      value: rProvider.remainder,
                      onChanged: (val) {
                        rProvider.toogleRemaider();
                        provider.toogleRemaider();
                      },
                    ),
                  ),
                ),
                Space.h20,
                ScrollTimePicker(
                  disable: !rProvider.remainder,
                  onTimeChanged: (p0) {
                    rProvider.updateTime(p0);
                    provider.updateTime(p0);
                  },
                ),
                Space.h20,
                Row(
                  children: [
                    Text('Select Day', style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Space.h24,

                CreateWeekDays(
                  rProvider: rProvider,
                  disable: !rProvider.remainder,
                  onSelect: (val) {
                    provider.updateSelection(val);
                  },
                ),
                Space.h24,
              ],
            ),
          );
        },
      ),
    );
  }
}
