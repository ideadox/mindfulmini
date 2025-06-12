import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_screen_size.dart';

import 'package:mindfulminis/features/authentication/providers/phone_authh_provider.dart';
import 'package:mindfulminis/features/home/providers/rating_provider.dart';
import 'package:mindfulminis/features/offline_status/providers/offline_status_provider.dart';
import 'package:mindfulminis/features/onbaord/providers/onboards_provider.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import 'common/providers/audio_manager.dart';

class Mindfulminis extends StatelessWidget {
  const Mindfulminis({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PhoneAuthhProvider()),
        ChangeNotifierProvider(create: (context) => OnboardsProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => OfflineStatusProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AudioManager()),

        ChangeNotifierProvider(create: (context) => RatingProvider()),
      ],
      child: MaterialApp.router(
        builder: FlutterSmartDialog.init(
          builder: (context, child) {
            ScreenSize.width = MediaQuery.sizeOf(context).width;
            ScreenSize.height = MediaQuery.sizeOf(context).height;
            final mediaQueryData = MediaQuery.of(context);

            final scale = mediaQueryData.textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.3,
            );
            return MediaQuery(
              data: mediaQueryData.copyWith(textScaler: scale),
              child: child!,
            );
          },
        ),

        title: 'Mindfulminis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          fontFamily: 'New Hero',
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          colorScheme: ColorScheme.light(primary: AppColors.primary),
          useMaterial3: true,
        ),

        routerConfig: sl<GoRouter>(),
      ),
    );
  }
}
