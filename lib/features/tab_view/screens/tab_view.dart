import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/features/offline_status/providers/offline_status_provider.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';

import 'package:mindfulminis/features/tab_view/widgets/icon_animate_switcher.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../common/bottom_bar/src/custom_navigation_bar_item.dart';
import '../../../common/bottom_bar/src/custome_navigation_bar.dart';
import '../../../services/push_notification_service.dart';
import '../../home/widgets/feedback/feedback_dailog.dart';
import '../../offline_status/screens/offline_screen.dart';
import '../../sidhi/screens/shidi_chat_screen.dart';
import '../models/tabview_model.dart';
import '../providers/tab_view_provider.dart';
import '../widgets/tab_text.dart';

class TabView extends StatefulWidget {
  static String routeName = 'tab-view';
  static String routePath = '/tab-view';
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  final List<TabviewModel> tabs = [
    TabviewModel(title: 'Home', lottieIcon: Assets.tabicons.homeTabLottine),
    TabviewModel(title: 'Activity', lottieIcon: Assets.tabicons.activityLottie),

    TabviewModel(title: 'Journal', lottieIcon: Assets.tabicons.journalLottie),
    TabviewModel(title: 'Routine', lottieIcon: Assets.tabicons.routineLottie),
    TabviewModel(title: 'Profile', lottieIcon: Assets.tabicons.profileLottie),
  ];

  @override
  void initState() {
    _controllers = List.generate(
      tabs.length,
      (_) => AnimationController(vsync: this),
    );

    PushNotificationService().initToken();
    context.read<ProfileProvider>().getUser();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      for (int i = 0; i < _controllers.length; i++) {
        if (i == index) {
          _controllers[i].forward(from: 0);
        } else {
          _controllers[i].reset();
        }
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabViewProvider()),
      ],

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
                    items: List.generate(tabs.length, (index) {
                      final tab = tabs[index];
                      return CustomNavigationBarItem(
                        icon: LottieBuilder.asset(
                          tab.lottieIcon,
                          controller: _controllers[index],
                          repeat: false,
                          onLoaded: (composition) {
                            _controllers[index]
                              ..duration = composition.duration
                              ..reset();
                            if (index == 0) {
                              _controllers[index].animateTo(1);
                            }
                          },
                        ),

                        title: TabText(
                          title: tab.title,
                          selected: provider.currentIndex == index,
                        ),
                      );
                    }),

                    currentIndex: provider.currentIndex,
                    onTap: (index) {
                      if (index == provider.currentIndex) {
                        return;
                      }
                      provider.onChangeIndex(index);
                      _onItemTapped(index);
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



  // [
  //                     CustomNavigationBarItem(
  //                       // icon: SvgPicture.asset(Assets.tabicons.home1),
  //                       icon: LottieBuilder.asset(
  //                         lottiePaths[0],
  //                         controller: _controllers[0],
  //                         repeat: false,
  //                         onLoaded: (composition) {
  //                           _controllers[0]
  //                             ..duration = composition.duration
  //                             ..reset();
  //                           _controllers[0].animateTo(1);
  //                         },
  //                       ),
  //                       // selectedIcon: SvgPicture.asset(Assets.tabicons.home5),
  //                       title: TabText(
  //                         title: 'Home',
  //                         selected: provider.currentIndex == 0,
  //                       ),
  //                     ),
  //                     CustomNavigationBarItem(
  //                       icon: SvgPicture.asset(Assets.icons.activityUnselected),
  //                       selectedIcon: SvgPicture.asset(
  //                         Assets.icons.activitySelected,
  //                       ),
  //                       title: TabText(
  //                         title: 'Activity',
  //                         selected: provider.currentIndex == 1,
  //                       ),
  //                     ),
  //                     CustomNavigationBarItem(
  //                       icon: SvgPicture.asset(Assets.icons.journelUnselcted),
  //                       selectedIcon: SvgPicture.asset(
  //                         Assets.icons.journelSelected,
  //                       ),
  //                       title: TabText(
  //                         title: 'Journal',
  //                         selected: provider.currentIndex == 2,
  //                       ),
  //                     ),
  //                     CustomNavigationBarItem(
  //                       icon: SvgPicture.asset(Assets.icons.routineUnselected),
  //                       selectedIcon: SvgPicture.asset(
  //                         Assets.icons.routineSelected,
  //                       ),
  //                       title: TabText(
  //                         title: 'Routine',
  //                         selected: provider.currentIndex == 3,
  //                       ),
  //                     ),
  //                     CustomNavigationBarItem(
  //                       icon: SvgPicture.asset(Assets.icons.profileUnselected),
  //                       selectedIcon: Image.asset(
  //                         Assets.icons.profileSelected.path,
  //                       ),
  //                       title: TabText(
  //                         title: 'Profile',
  //                         selected: provider.currentIndex == 4,
  //                       ),
  //                     ),
  //                   ],