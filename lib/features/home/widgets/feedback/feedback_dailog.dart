import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/home/providers/rating_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/close_button_dailog.dart';
import '../../../../core/app_colors.dart';

class FeedbackDailog extends StatelessWidget {
  const FeedbackDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingProvider>(
      builder: (context, rp, _) {
        double height = 488;
        if (rp.ratingCount == 0) {
          height = 488;
        }
        if (rp.ratingCount >= 1 && rp.ratingCount <= 3) {
          height = 640;
        }

        if (rp.ratingCount >= 4) {
          height = 510;
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),

          child: Container(
            height: height,
            width: MediaQuery.sizeOf(context).width * 0.92,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(Assets.vectors.ratingTopVectot.path),
                      Image.asset(Assets.vectors.ratingBottomVector.path),
                    ],
                  ),
                ),

                Positioned.fill(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 800),
                              child: BuildImage(rating: rp.ratingCount),
                            ),
                            Space.h16,
                            if (rp.ratingCount != 0)
                              BuildText(rating: rp.ratingCount),
                            Space.h16,

                            if (rp.ratingCount == 0)
                              Column(
                                children: [
                                  Text(
                                    'Rate your experience!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Space.h16,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Give us ',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback:
                                            (bounds) => LinearGradient(
                                              colors: [
                                                HexColor('#F95D11'),
                                                HexColor('#FCCB6C'),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ).createShader(
                                              Rect.fromLTWH(
                                                0,
                                                0,
                                                bounds.width,
                                                bounds.height,
                                              ),
                                            ),
                                        child: Text(
                                          '5 stars ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'if you like',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Space.h16,
                                ],
                              ),
                            SizedBox(
                              height: 38,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: BuildStar(
                                      onPressedl: () {
                                        rp.onChnageRating(1);
                                      },
                                      isColor: 1 <= rp.ratingCount,
                                    ),
                                  ),
                                  Expanded(
                                    child: BuildStar(
                                      onPressedl: () {
                                        rp.onChnageRating(2);
                                      },
                                      isColor: 2 <= rp.ratingCount,
                                    ),
                                  ),
                                  Expanded(
                                    child: BuildStar(
                                      onPressedl: () {
                                        rp.onChnageRating(3);
                                      },
                                      isColor: 3 <= rp.ratingCount,
                                    ),
                                  ),
                                  Expanded(
                                    child: BuildStar(
                                      onPressedl: () {
                                        rp.onChnageRating(4);
                                      },
                                      isColor: 4 <= rp.ratingCount,
                                    ),
                                  ),
                                  Expanded(
                                    child: BuildStar(
                                      onPressedl: () {
                                        rp.onChnageRating(5);
                                      },
                                      isColor: 5 <= rp.ratingCount,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (rp.ratingCount != 0)
                              Column(
                                crossAxisAlignment:
                                    rp.ratingCount >= 4
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                children: [
                                  Space.h16,
                                  if (rp.ratingCount <= 3) ...[
                                    Text(
                                      'What can we improve?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Space.h8,

                                    Container(
                                      height: 120,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: TextFormField(
                                        maxLines: 5,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          hintText: 'Tell us in words..',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                          // border:
                                          // OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(
                                          //     30,
                                          //   ),
                                          //   borderSide: BorderSide(
                                          //     color: Colors.grey.shade300,
                                          //   ),
                                          // ),
                                          // enabledBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(
                                          //     30,
                                          //   ),
                                          //   borderSide: BorderSide(
                                          //     color: Colors.grey.shade300,
                                          //   ),
                                          // ),
                                          // focusedBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(
                                          //     30,
                                          //   ),
                                          //   borderSide: BorderSide(
                                          //     color: AppColors.purple,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  if (rp.ratingCount >= 4) ...[
                                    Text(
                                      'What can we improve?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Space.h4,
                                    Text(
                                      'Would you like to rate us on Playstore?',
                                    ),
                                  ],
                                  Space.h20,

                                  GradientButton(
                                    onPressed: () {},
                                    child: Center(
                                      child: Text(
                                        rp.ratingCount >= 4
                                            ? 'Rate on Playstore'
                                            : 'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    SmartDialog.dismiss();
                  },
                  child: CloseButtonDailog(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BuildStar extends StatelessWidget {
  final VoidCallback onPressedl;
  final bool isColor;
  const BuildStar({super.key, required this.onPressedl, required this.isColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedl,
      child:
          isColor
              ? SvgPicture.asset(Assets.icons.starYellow)
              : SvgPicture.asset(Assets.vectors.uncolorStar),
    );
  }
}

class BuildImage extends StatelessWidget {
  final int rating;
  const BuildImage({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    switch (rating) {
      case 1:
        return SizedBox(
          height: 140,
          child: Image.asset(key: ValueKey(1), Assets.icons.oneStarRating.path),
        );

      case 2:
        return SizedBox(
          height: 140,
          child: Image.asset(key: ValueKey(2), Assets.icons.twoStarRating.path),
        );

      case 3:
        return SizedBox(
          height: 140,
          child: Image.asset(
            key: ValueKey(3),
            Assets.icons.threeStarRating.path,
          ),
        );
      case 4:
        return SizedBox(
          height: 184,
          child: Image.asset(
            key: ValueKey(4),
            Assets.icons.fourStarRating.path,
          ),
        );
      case 5:
        return SizedBox(
          height: 184,
          child: Image.asset(
            key: ValueKey(5),
            Assets.icons.fiveStarRating.path,
          ),
        );

      default:
        SizedBox(
          height: 140,
          child: Image.asset(key: ValueKey(0), Assets.icons.noRating.path),
        );
    }
    return SizedBox(
      height: 140,
      child: Image.asset(key: ValueKey(0), Assets.icons.noRating.path),
    );
  }
}

class BuildText extends StatelessWidget {
  final int rating;

  const BuildText({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    switch (rating) {
      case 1:
        return Text(
          'Very Bad!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );

      case 2:
        return Text(
          'Very Bad!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );

      case 3:
        return Text(
          'Average!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );
      case 4:
        return Text(
          'Good!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );
      case 5:
        return Text(
          'Love It!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );

      default:
        return Text(
          '',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );
    }
  }
}
