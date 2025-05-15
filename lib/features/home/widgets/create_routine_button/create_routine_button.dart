import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/features/routine/screens/my_routine_screen.dart';
import 'package:mindfulminis/injection/injection.dart';

class CreateRoutineButton extends StatelessWidget {
  const CreateRoutineButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: GradientButton(
        onPressed: () {
          sl<GoRouter>().pushNamed(MyRoutineScreen.routeName);
        },
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
