import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/offline_status/providers/offline_status_provider.dart';

import 'package:mindfulminis/features/tab_view/widgets/icon_animate_switcher.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../common/bottom_bar/src/custom_navigation_bar_item.dart';
import '../../../common/bottom_bar/src/custome_navigation_bar.dart';
import '../../offline_status/screens/offline_screen.dart';
import '../../sidhi/screens/shidi_chat_screen.dart';
import '../../subscription/widgets/subscription_sheet.dart';
import '../providers/tab_view_provider.dart';
import '../widgets/tab_text.dart';

class TabView extends StatelessWidget {
  static String routeName = 'tab-view';
  static String routePath = '/tab-view';
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<IconFrameAnimatorState>> animatorKeys = [
      GlobalKey<IconFrameAnimatorState>(),
      GlobalKey<IconFrameAnimatorState>(),
    ];
    return ChangeNotifierProvider(
      create: (context) => TabViewProvider(),
      child: Consumer2<TabViewProvider, OfflineStatusProvider>(
        builder: (context, provider, osp, _) {
          return Stack(
            children: [
              Scaffold(
                extendBody: true,
                body:
                    !osp.connected
                        ? OfflineScreen()
                        : provider.screens[provider.currentIndex],
                floatingActionButton: IconButton(
                  onPressed: () {
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   backgroundColor: Colors.transparent,
                    //   builder: (context) {
                    //     return SubscriptionSheet();
                    //   },
                    // );

                    sl<GoRouter>().pushNamed(ShidiChatScreen.routeName);
                  },
                  icon: Image.asset(Assets.icons.floatingButton.path),
                ),
                bottomNavigationBar: SizedBox(
                  height: 80,
                  child: CustomNavigationBar(
                    borderRadius: Radius.circular(50),
                    iconSize: 28.0,
                    selectedColor: Colors.transparent,
                    strokeColor: Colors.transparent,
                    unSelectedColor: Color(0xffacacac),
                    backgroundColor: Colors.blueGrey.shade50,
                    items: [
                      CustomNavigationBarItem(
                        // icon: IconFrameAnimator(
                        //   key: _animatorKeys[0],
                        //   icons: [
                        //     SvgPicture.asset(Assets.tabicons.home1),
                        //     SvgPicture.asset(Assets.tabicons.home2),
                        //     SvgPicture.asset(Assets.tabicons.home3),

                        //     SvgPicture.asset(Assets.tabicons.home4),
                        //     SvgPicture.asset(Assets.tabicons.home5),
                        //   ],
                        // ),
                        icon: SvgPicture.asset(Assets.tabicons.home1),
                        selectedIcon: SvgPicture.asset(Assets.tabicons.home5),
                        title: TabText(
                          title: 'Home',
                          selected: provider.currentIndex == 0,
                        ),
                      ),
                      CustomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.icons.activityUnselected),
                        selectedIcon: SvgPicture.asset(
                          Assets.icons.activitySelected,
                        ),
                        title: TabText(
                          title: 'Activity',
                          selected: provider.currentIndex == 1,
                        ),
                      ),
                      CustomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.icons.journelUnselcted),
                        selectedIcon: SvgPicture.asset(
                          Assets.icons.journelSelected,
                        ),
                        title: TabText(
                          title: 'Journal',
                          selected: provider.currentIndex == 2,
                        ),
                      ),
                      CustomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.icons.routineUnselected),
                        selectedIcon: SvgPicture.asset(
                          Assets.icons.routineSelected,
                        ),
                        title: TabText(
                          title: 'Routine',
                          selected: provider.currentIndex == 3,
                        ),
                      ),
                      CustomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.icons.profileUnselected),
                        selectedIcon: Image.asset(
                          Assets.icons.profileSelected.path,
                        ),
                        title: TabText(
                          title: 'Profile',
                          selected: provider.currentIndex == 4,
                        ),
                      ),
                    ],
                    currentIndex: provider.currentIndex,
                    onTap: (index) {
                      provider.onChangeIndex(index);
                      // _animatorKeys[0].currentState?.startAnimation();
                    },
                  ),
                ),
              ),

              // Positioned(
              //   bottom: 110,
              //   right: 120,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //     decoration: BoxDecoration(
              //       color: Colors.deepPurple,
              //       borderRadius: BorderRadius.circular(12),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black26,
              //           blurRadius: 6,
              //           offset: Offset(0, 3),
              //         ),
              //       ],
              //     ),
              //     child: Text(
              //       "Hi there!\nI'm Sidhi",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
