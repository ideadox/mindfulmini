import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';

class CreateRoutineButton extends StatelessWidget {
  const CreateRoutineButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: GradientButton(
        onPressed: () {},
        child: Center(
          child: Text(
            'Create routine',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
