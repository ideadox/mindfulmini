import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/close_button_dailog.dart';
import '../../../common/widgets/gradient_button.dart';
import '../../../gen/assets.gen.dart';

class AllsetDailog extends StatelessWidget {
  final VoidCallback onGoToHome;
  final VoidCallback onCancel;

  const AllsetDailog({
    super.key,
    required this.onGoToHome,
    required this.onCancel,
  });

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
          InkWell(onTap: onCancel, child: CloseButtonDailog()),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "You're all set!",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                ),
                SizedBox(height: 20),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Get ready to explore mindful moments, fun activities, and calming exercises. Let’s begin your journey!"',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                SvgPicture.asset(Assets.images.allset, height: height * 0.2),
                SizedBox(height: 20),

                SizedBox(
                  width: width * 0.4,
                  height: 50,
                  child: GradientButton(
                    onPressed: onGoToHome,
                    child: Center(
                      child: Text(
                        'Go To Home',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
