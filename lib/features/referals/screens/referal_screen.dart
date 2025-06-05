import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/widgets/custom_back_button.dart';
import '../widgets/referal_info.dart';

class ReferalScreen extends StatelessWidget {
  static String routeName = 'referal-screen';
  static String routePath = '/referal-screen';

  const ReferalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text(
          'Referral Friends',
          // style: Texst(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(Assets.images.referalBgm.path),
                  Positioned(
                    top: 180,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'Invite 3 friends, Get \n3 months free!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Space.h16,
                        Text(
                          'Invite friends to join Mindful Minis and get 3 \nmonths free (45 value) when they join',
                          textAlign: TextAlign.center,

                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Space.h16,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [AddContactIcon()],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ReferalInfo(),
              Space.h16,

              LinkContainer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: GradientButton(
          onPressed: () {
            SharePlus.instance.share(
              ShareParams(text: 'check out my website https://example.com'),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Send referral link',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Space.w8,
              Icon(Icons.ios_share, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class AddContactIcon extends StatelessWidget {
  const AddContactIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Icon(Icons.add_circle_outline, color: Colors.black54, size: 34),
    );
  }
}

class LinkContainer extends StatelessWidget {
  const LinkContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: HexColor('#E1E2F7')),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'https://mindfulminis.com/search/ios',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              FlutterClipboard.copy('https://mindfulminis.com/search/ios');
            },
            child: Icon(Icons.content_copy),
          ),
        ],
      ),
    );
  }
}
