import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GradientScaffold extends StatelessWidget {
  final Widget? appbar;
  final Widget? body;
  const GradientScaffold({super.key, this.body, this.appbar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HexColor('#FFF9E8'),
              HexColor('#D4E1FE'),
              HexColor('#FDE8EF'),
              HexColor('#FFF4EE'),
            ],
          ),
        ),
        child: SafeArea(child: body!),
      ),
    );
  }
}
