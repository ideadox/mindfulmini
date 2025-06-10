import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/widgets/close_button_dailog.dart';
import '../../../common/widgets/gradient_button.dart';
import '../../signup/screens/create_account.dart';

class VerificationCompleteDailog extends StatelessWidget {
  const VerificationCompleteDailog({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height * 0.6,
      width: width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          image: AssetImage(Assets.images.ellipse70951.path),
        ),
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          CloseButtonDailog(),

          Lottie.asset(Assets.images.verifiedlottie, height: height * 0.25),
          Text(
            'Successfully Verified',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Get ready to onboard our  mindful moments.'),
              ],
            ),
          ),
          SizedBox(height: 20),

          SizedBox(
            width: width * 0.3,
            height: 45,
            child: GradientButton(
              onPressed: () {
                sl<GoRouter>().pushNamed(KidName.routeName);
              },
              child: Center(
                child: Text(
                  'Next',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
