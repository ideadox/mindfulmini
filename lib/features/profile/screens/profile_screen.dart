import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../widgets/mini_plus_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: Scaffold(
        body: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HexColor('#9D9FE6'),
                    HexColor('#FFFFFF'),
                    HexColor('#FFFFFF'),
                    HexColor('#FFFFFF'),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: kToolbarHeight),

                    ListTile(
                      leading: Container(
                        height: 72,
                        width: 72,
                        padding: EdgeInsets.all(4),

                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              Assets.profileIcons.gardintCircularPng.path,
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(
                            255,
                            235,
                            227,
                            252,
                          ),
                          backgroundImage: AssetImage(
                            Assets.profileIcons.noProfilePng.path,
                          ),
                        ),
                      ),
                      title: Text(
                        'Alex',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        'alexmish12@gmail.com',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),

                    Space.h12,

                    MiniPlusCard(),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.items.length,

                      itemBuilder: (context, index) {
                        var item = provider.items[index];

                        bool hasButton =
                            item['hasButton'] == 'true' ? true : false;

                        bool hasTrailing =
                            item['trailing'] == 'true' ? true : false;
                        bool hasDivider =
                            item['divider'] == 'true' ? true : false;
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                if (index == 0) {
                                  provider.navigateToEditProfile();
                                  return;
                                }

                                if (index == 3) {
                                  provider.navigateToAnalytices();
                                  return;
                                }
                                if (index == 7) {
                                  provider.navigateToAppSetting();
                                  return;
                                }
                                if (index == 5) {
                                  provider.navigateToLanguage();
                                  return;
                                }
                              },
                              title: Text(
                                item['name'] ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                              leading: SvgPicture.asset(item['icon'] ?? ''),
                              trailing:
                                  hasTrailing
                                      ? hasButton
                                          ? CupertinoSwitch(
                                            value: false,
                                            onChanged: (val) {},
                                          )
                                          : Icon(Icons.chevron_right)
                                      : null,
                            ),
                            if (hasDivider)
                              Divider(thickness: 0.4, color: AppColors.grey45),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: kToolbarHeight + 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
