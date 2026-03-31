import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/features/routine/screens/my_routine_screen.dart';
import 'package:mindfulminis/core/injection/injection.dart';

class CreateRoutineButton extends StatelessWidget {
  const CreateRoutineButton({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return SizedBox(
      width: 130,
      child: GradientButton(
        onPressed: () {
          sl<GoRouter>().pushNamed(MyRoutineScreen.routeName);
        },
        child: Center(
          child: Text(
            strings.home('create_routine.cta', fallback: 'Create routine'),
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
