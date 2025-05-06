import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/injection/injection.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        sl<GoRouter>().pop();
      },
      icon: Icon(Icons.arrow_back_ios_new_outlined),
    );
  }
}
