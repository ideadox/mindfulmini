import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GradientScaffold extends StatelessWidget {
  final Widget? appbar;
  final Widget? body;
  final bool hasGradient;
  final bool resizeToAvoidBottomInset;
  const GradientScaffold({
    super.key,
    this.body,
    this.appbar,
    this.hasGradient = true,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Container(
        height: double.infinity,
        width: double.infinity,

        decoration: BoxDecoration(
          color: hasGradient ? null : Colors.white,
          gradient:
              hasGradient
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HexColor('#FFF9E8'),
                      HexColor('#D4E1FE'),
                      HexColor('#FDE8EF'),
                      HexColor('#FFF4EE'),
                    ],
                  )
                  : null,
        ),
        child: SafeArea(child: body!),
      ),
    );
  }
}
