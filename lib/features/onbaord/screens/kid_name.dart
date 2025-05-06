import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/common_close_button.dart';
import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/onbaord/screens/dob.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class KidName extends StatelessWidget {
  static String routeName = 'kid-name';
  static String routePath = '/kid-name';

  const KidName({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CommonCloseButton()],
            ),
            Text(
              'Your kid’s name',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Enter any cute or funny name that your kids like the most',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: AppColors.grey45,
              ),
            ),
            SizedBox(height: 30),

            CommonTextFormField(
              prefixIcon: SvgPicture.asset(Assets.icons.user),
              hintText: 'Enter Name',
            ),

            Spacer(),
            GradientButton(
              onPressed: () {
                sl<GoRouter>().pushNamed(Dob.routeName);
              },
              child: Center(child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
