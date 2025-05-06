import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/features/authentication/screens/auth_main.dart';
import 'package:mindfulminis/features/onboarding/providers/onboard_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../injection/injection.dart';

class OnboardScreen extends StatelessWidget {
  static String routeName = 'onboard-screen';
  static String routePath = '/onboard-screen';
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return ChangeNotifierProvider(
      create: (context) => OnboardProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<OnboardProvider>(
          builder: (context, op, _) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: op.controller,
                    onPageChanged: (value) {
                      op.pageChanged(value);
                    },
                    children: [
                      BuildOnboardPage(
                        controller: op.controller,
                        img: op.pageData[0]['img'] ?? '',

                        title: op.pageData[0]['title'] ?? '',
                        body: op.pageData[0]['body'] ?? '',
                      ),

                      BuildOnboardPage(
                        controller: op.controller,
                        img: op.pageData[1]['img'] ?? '',

                        title: op.pageData[1]['title'] ?? '',
                        body: op.pageData[1]['body'] ?? '',
                      ),
                      BuildOnboardPage(
                        controller: op.controller,
                        img: op.pageData[2]['img'] ?? '',
                        title: op.pageData[2]['title'] ?? '',
                        body: op.pageData[2]['body'] ?? '',
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SmoothPageIndicator(
                        controller: op.controller,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          dotColor: Colors.black12,
                          activeDotColor: Colors.black,
                        ),
                      ),

                      SizedBox(height: 30),
                      SizedBox(
                        width: width * 0.7,
                        child: GradientButton(
                          onPressed: () {
                            if (op.currentPage == 2) {
                              sl<GoRouter>().pushReplacementNamed(
                                AuthMain.routeName,
                              );
                              return;
                            }
                            context.read<OnboardProvider>().jumpToPage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class BuildOnboardPage extends StatelessWidget {
  final String title;
  final String body;
  final String img;
  final PageController controller;
  const BuildOnboardPage({
    super.key,
    required this.controller,
    required this.body,
    required this.title,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [HexColor('#D4D6FF'), Colors.white],
        ),
        image: DecorationImage(
          alignment: Alignment.center,
          image: AssetImage(Assets.images.onboardBackgroundPng.path),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(img),
            SizedBox(height: 40),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: body,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
