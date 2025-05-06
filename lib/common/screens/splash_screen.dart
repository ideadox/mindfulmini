import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/features/onboarding/screens/onboard_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../injection/injection.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash-screen';
  static String routePath = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      sl<GoRouter>().pushReplacementNamed(OnboardScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor('#9D9FE6'),
                  HexColor('#9D9FE6'),

                  HexColor('#CFC0FF'),
                  HexColor('#CFC0FF'),
                ],
              ),
            ),
            child: Center(child: SvgPicture.asset(Assets.images.splashImg)),
          ),
          Positioned(bottom: 0, child: SvgPicture.asset(Assets.images.splash1)),
          Positioned(bottom: 20, child: SvgPicture.asset(Assets.images.star)),
          Positioned(
            bottom: 60,
            left: 20,
            child: SvgPicture.asset(Assets.images.star1),
          ),
          Positioned(bottom: 150, child: SvgPicture.asset(Assets.images.star2)),
        ],
      ),
    );
  }
}
