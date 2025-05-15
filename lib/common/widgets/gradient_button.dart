import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final bool hasShadow;
  final void Function()? onPressed;
  const GradientButton({
    super.key,
    required this.child,
    this.onPressed,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          boxShadow:
              !hasShadow
                  ? null
                  : [
                    BoxShadow(
                      color: Colors.grey.shade50,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
          color: onPressed != null ? null : HexColor('#EAEBFF'),
          gradient:
              onPressed == null
                  ? null
                  : LinearGradient(
                    colors: [
                      HexColor('#6E40F9'),
                      HexColor('#A569FB'),
                      HexColor('#CE89FF'),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: child,
      ),
    );
  }
}
