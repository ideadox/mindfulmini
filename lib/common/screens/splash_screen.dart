import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/features/onboarding/screens/onboard_screen.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/services/storage/token_storage.dart';

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
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final tokenStorage = sl<TokenStorage>();
      final token = await tokenStorage.getAccessToken();

      // Check if user is properly authenticated (both Firebase user and token exist)
      final isAuthenticated = firebaseUser != null && 
                              token != null && 
                              token.isNotEmpty;

      if (isAuthenticated) {
        log('✅ User is authenticated, navigating to TabView');
        if (mounted) {
          sl<GoRouter>().pushReplacementNamed(TabView.routeName);
        }
      } else {
        log('ℹ️ User not authenticated, navigating to OnboardScreen');
        if (mounted) {
          sl<GoRouter>().pushReplacementNamed(OnboardScreen.routeName);
        }
      }
    } catch (e) {
      log('❌ Error checking auth state: $e');
      // On error, default to onboard screen
      if (mounted) {
        sl<GoRouter>().pushReplacementNamed(OnboardScreen.routeName);
      }
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
