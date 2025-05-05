import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mindfulminis/features/authentication/providers/phone_authh_provider.dart';
import 'package:mindfulminis/features/onboarding/screens/onboard_screen.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class Mindfulminis extends StatelessWidget {
  const Mindfulminis({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PhoneAuthhProvider()),
      ],
      child: MaterialApp(
        title: 'Mindfulminis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: Assets.fonts.newHeroRegular,
          textTheme: TextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        navigatorObservers: [FlutterSmartDialog.observer],
        // here
        builder: FlutterSmartDialog.init(),
        home: OnboardScreen(),
      ),
    );
  }
}
