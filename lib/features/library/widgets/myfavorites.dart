import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../../common/widgets/gradient_button.dart';
import '../../../common/widgets/video_progress_bar.dart';
import 'library_empty_data.dart';

class Myfavorites extends StatelessWidget {
  const Myfavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return MyfavoritesData();
  }
}

class MyfavoritesData extends StatelessWidget {
  const MyfavoritesData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Space.h16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      'Stories Liked',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    CustomGradientText(text: 'See All'),
                  ],
                ),
              ),
              Space.h16,
              SizedBox(
                height: 314,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => Space.w12,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 268,
                              width: 177,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Assets.dummy.story.path),
                                ),
                              ),
                            ),

                            Container(
                              height: 268,
                              width: 177,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.5),
                                    Colors.black.withValues(alpha: 0.3),

                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VideoProgressBar(progress: 0.3),
                                  Space.h8,
                                  SizedBox(
                                    height: 29,
                                    width: 76,
                                    child: GradientButton(
                                      hasShadow: false,
                                      onPressed: () {},
                                      child: Center(
                                        child: Text(
                                          'Resume',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
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
                        Space.h16,
                        Row(
                          children: [
                            Container(
                              height: 24,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AppColors.grey45),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(Assets.icons.timeCircle),
                                  Text(
                                    '5 minutes',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Space.h16,
            ],
          ),
        ),
      ],
    );
  }
}

class MyFavEmpty extends StatelessWidget {
  const MyFavEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return LibraryEmptyData(
      icon: Assets.images.myfavImg.path,
      title: 'You haven’t favorited any tracks ',
      subtitle: 'Tap on the 🤍 icon to add your favourite content to this list',
      space: true,
    );
  }
}
