import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/custom_back_button2.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class StoriesDownload extends StatelessWidget {
  static String routeName = 'stories-download';
  static String routePath = '/stories-download';

  const StoriesDownload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Image.asset(Assets.vectors.storiesTop.path),
            ),
            Positioned(
              left: 0,
              bottom: 100,

              child: Image.asset(Assets.vectors.storiesLeft.path),
            ),
            Positioned(
              bottom: 120,
              right: -50,
              child: Image.asset(Assets.vectors.storiesRight.path),
            ),

            Positioned(top: 50, left: 20, child: CustomBackButton2()),

            Positioned(
              top: 170,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Image.asset(Assets.images.storiesTree.path),
                  Space.h20,
                  Text(
                    'The mango Tree',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Space.h8,
                  Text(
                    textAlign: TextAlign.center,
                    'The Mango Tree" teaches that true prosperity comes from unity and sharing, showing how cooperation fosters abundance and harmony for all.',
                    style: TextStyle(color: Colors.black45),
                  ),
                  Space.h32,
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Space.h32,

                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      maximumSize: const Size(50, 50),
                      minimumSize: const Size(50, 50),
                      alignment: Alignment.center,
                      backgroundColor: Colors.grey.shade300,
                    ),

                    icon: SvgPicture.asset(
                      Assets.icons.playButton,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
