import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/close_button_dailog.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class CompleteAffirmationDialog extends StatelessWidget {
  const CompleteAffirmationDialog({super.key});

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
      child: Stack(
        children: [
          Positioned(
            bottom: -80,
            left: 0,
            right: 0,
            child: Image.asset(Assets.vectors.bubbleBlast.path),
          ),

          Column(
            children: [
              InkWell(
                onTap: () {
                  sl<GoRouter>().pop();
                },
                child: CloseButtonDailog(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Awesome!\nYou’ve completed your affirmation!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            style: TextStyle(fontWeight: FontWeight.w500),
                            text:
                                '🌟 Take a deep breath and feel the positivity. Now, let’s move on to your next task!"',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    SvgPicture.asset(Assets.icons.yellowStar),
                    SizedBox(height: 20),

                    SizedBox(
                      width: width * 0.4,
                      height: 50,
                      child: GradientButton(
                        onPressed: () {
                          sl<GoRouter>().pop();
                        },
                        child: Center(
                          child: Text(
                            'Next',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
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
        ],
      ),
    );
  }
}
