import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/close_button_dailog.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class CelebrateDailog extends StatelessWidget {
  final VoidCallback onNext;
  const CelebrateDailog({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: height * 0.35,
          width: width * 0.9,
          margin: EdgeInsets.only(bottom: 230),
          child: SvgPicture.asset(Assets.images.celebrateContinue),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: height * 0.35,
            width: width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.bottomCenter,
                image: AssetImage(Assets.images.ellipse709512.path),
              ),
              color: Colors.white,

              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                CloseButtonDailog(),

                Text(
                  textAlign: TextAlign.center,
                  'Congratulation',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                ),
                SizedBox(height: 20),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'A little thanks goes a long way. See you tomorrow! 😊 ',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: width * 0.6,
                  height: 45,
                  child: GradientButton(
                    onPressed: onNext,
                    child: Center(
                      child: Text(
                        '🎈 Celebrate & Continue',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
