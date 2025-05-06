import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/widgets/gradient_button.dart';
import '../../signup/screens/create_account.dart';

class VerificationCompleteDailog extends StatelessWidget {
  const VerificationCompleteDailog({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      height: 400,
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
          CloseButton(),
          SizedBox(height: 150),

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
                sl<GoRouter>().pushNamed(CreateAccount.routeName);
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

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 6,
                  blurRadius: 5,
                  offset: const Offset(1, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
