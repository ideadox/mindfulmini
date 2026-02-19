import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/features/onboarding/screens/onboard_screen.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/services/auth_service.dart';

import '../../core/injection/injection.dart';

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
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authService = sl<AuthService>();

    if (authService.isAuthenticated) {
      log('✅ Authenticated (${authService.currentUser!.uid}) → TabView');
      if (mounted) sl<GoRouter>().goNamed(TabView.routeName);
    } else {
      log('ℹ️ Not authenticated → OnboardScreen');
      if (mounted) sl<GoRouter>().goNamed(OnboardScreen.routeName);
    }
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
            child: Center(child: SvgPicture.asset(Assets.images.splashImg1)),
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
