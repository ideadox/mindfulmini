import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.offlineBackground.path),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight),

          Stack(
            alignment: Alignment.center,

            children: [
              Center(
                child: SvgPicture.asset(
                  Assets.icons.homeTopLogo,
                  width: 70,
                  height: 40,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(Assets.icons.notification),
                  ),
                ],
              ),
            ],
          ),
          Space.h40,
          Space.h40,

          Image.asset(Assets.images.offlineImg.path),
          Space.h12,

          Text(
            'Oops! Something went wrong!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Space.h12,
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Text(
              'Please check your internet connection and try again later, or you can still listen to our awesome content in Offline Mode!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Space.h32,
          Text(
            'Offline Mode',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
