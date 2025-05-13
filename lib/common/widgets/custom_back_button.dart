import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/injection/injection.dart';

class CustomBackButton extends StatelessWidget {
  final bool hasBackground;
  const CustomBackButton({super.key, this.hasBackground = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          !hasBackground
              ? null
              : BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
      child: IconButton(
        onPressed: () {
          sl<GoRouter>().pop();
        },
        icon: Icon(Icons.arrow_back_ios_new_outlined),
        color: Colors.black,
      ),
    );
  }
}
