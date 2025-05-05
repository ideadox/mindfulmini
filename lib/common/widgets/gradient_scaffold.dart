import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget? appbar;
  final Widget? body;
  const GradientScaffold({super.key, this.body, this.appbar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     const Color.fromARGB(255, 254, 254, 186),
            //     const Color.fromARGB(255, 118, 152, 238),
            //     const Color.fromARGB(255, 241, 185, 180),
            //   ],
            // ),
          ),
          child: body,
        ),
      ),
    );
  }
}
