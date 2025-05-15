import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_checkbox.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/routine/providers/create_routine_provider.dart';
import 'package:mindfulminis/features/routine/screens/remainder_confirmation_screen.dart';
import 'package:mindfulminis/features/routine/widgets/create_routine_conatiner.dart';
import 'package:mindfulminis/features/routine/widgets/goal_routine_container.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

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
  final int totalSteps = 4;

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
                !isActive
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
    return GradientScaffold(
      body: ChangeNotifierProvider(
        create: (context) => CreateRoutineProvider(),
        child: Consumer<CreateRoutineProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Space.h12,
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

                Space.h20,

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
                              provider.routineTimeLine == null
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              'Continue',
                              style:
                                  provider.routineTimeLine == null
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
                              provider.routineTime == null
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              'Continue',
                              style:
                                  provider.routineTime == null
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
                              provider.routineSpendTime == null
                                  ? null
                                  : () {
                                    _goToStep(currentStep + 1);
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              'Continue',
                              style:
                                  provider.routineSpendTime == null
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
                              provider.routineTypes.length != 3
                                  ? null
                                  : () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      showDragHandle: true,
                                      builder: (context) {
                                        return RemainderConfirmationScreen(
                                          provider: provider,
                                        );
                                      },
                                    );

                                    // provider.showSuccessDailog();
                                    return;
                                  },
                          child: Center(
                            child: Text(
                              provider.routineTypes.length != 3
                                  ? 'Select ${3 - provider.routineTypes.length} More Activities'
                                  : 'Continue',
                              style:
                                  provider.routineTypes.length != 3
                                      ? null
                                      : AppTextTheme.mainButtonTextStyle(
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

          children: [
            Text(
              textAlign: TextAlign.center,
              'How many days for this fun routine?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h40,
            Space.h16,
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
                  radioValue: item['title'] ?? "",
                  groupValue: provider.routineTimeLine ?? "",
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
              'Which session would you like to pick?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h40,
            Space.h16,
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
                  radioValue: item['title'] ?? "",
                  groupValue: provider.routineTime ?? "",
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
              'How much time do kids need to spend?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h40,
            Space.h16,
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
                  radioValue: item['title'] ?? "",
                  groupValue: provider.routineSpendTime ?? "",
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
    double width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              textAlign: TextAlign.center,
              'What goals you want to focus on?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Space.h20,

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                mainAxisExtent: 175,
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
                  isSelected: provider.routineTypes.contains(item['title']),
                  onChanged: (val) {
                    provider.onChangeType(item['title']);
                  },
                );
              },
            ),
            Space.h12,
            if (provider.fourthPageData.length.isOdd)
              SizedBox(
                height: 175,
                width: (width / 2) - 18,
                child: GoalRoutineContainer(
                  title:
                      provider.fourthPageData[provider.fourthPageData.length -
                          1]['title'] ??
                      "",
                  icon:
                      provider.fourthPageData[provider.fourthPageData.length -
                          1]['icon'] ??
                      '',
                  isSelected: provider.routineTypes.contains(
                    provider.fourthPageData[provider.fourthPageData.length -
                        1]['title'],
                  ),
                  onChanged: (val) {
                    provider.onChangeType(
                      provider.fourthPageData[provider.fourthPageData.length -
                          1]['title'],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
