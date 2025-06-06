import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/close_button_dailog.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class CustomDailog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final VoidCallback onNext;
  const CustomDailog({
    super.key,
    required this.onNext,
    required this.title,
    required this.subTitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final dialogHeight = height * 0.35;
    final dialogWidth = width * 0.98;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: dialogHeight,
          width: dialogWidth,
          margin: EdgeInsets.only(bottom: dialogHeight * 0.5),
          child: SvgPicture.asset(
            Assets.images.daillogComplete,

            fit: BoxFit.contain,
          ),
        ),

        Positioned(
          bottom: 0,
          left: width * 0.05,
          right: width * 0.05,
          child: Container(
            height: dialogHeight,
            width: dialogWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.bottomCenter,
                image: AssetImage(Assets.images.ellipse709512.path),
                fit: BoxFit.fitWidth,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const CloseButtonDailog(),
                const SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: width * 0.6,
                  height: 45,
                  child: GradientButton(
                    onPressed: onNext,
                    child: Center(
                      child: Text(
                        buttonText,
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

        Positioned(
          top: height * 0.13,
          child: SvgPicture.asset(
            Assets.images.completeDailog1,

            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
