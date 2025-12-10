import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/features/home/providers/home_provider.dart';
import 'package:mindfulminis/features/offline_status/providers/offline_status_provider.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common/bottom_bar/src/custom_navigation_bar_item.dart';
import '../../../common/bottom_bar/src/custome_navigation_bar.dart';
import '../../../services/push_notification_service.dart';
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

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  BranchContentMetaData metadata = BranchContentMetaData();
  BranchLinkProperties lp = BranchLinkProperties();
  late BranchUniversalObject buo;
  late BranchEvent eventStandard;
  late BranchEvent eventCustom;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  static const imageURL =
      'https://raw.githubusercontent.com/RodrigoSMarques/flutter_branch_sdk/master/assets/branch_logo_qrcode.jpeg';

  @override
  void initState() {
    listenDynamicLinks();

    initDeepLinkData();
    _controllers = List.generate(
      tabs.length,
      (_) => AnimationController(vsync: this),
    );

    PushNotificationService().initToken();
    context.read<ProfileProvider>().getUser(notify: false);
    super.initState();
  }

  //

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.listSession().listen(
      (data) async {
        log('listenDynamicLinks - DeepLink Data: $data');
        controllerData.sink.add((data.toString()));
        // Check for $deeplink_path in Branch data
        final deeplinkPath = data[r'$deeplink_path'];
        if (deeplinkPath != null && deeplinkPath is String) {
          // Optional: delay slightly to avoid early navigation errors
          Future.delayed(Duration(milliseconds: 300), () {
            // Navigator.pushNamed(context, MyRoutineScreen.routeName);
            // sl<GoRouter>().push(deeplinkPath);
          });
          return;
        }
      },
      onError: (error) {
        log('listSession error: ${error.toString()}');
      },
    );
  }

  void initDeepLinkData() {
    String dateString = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());

    metadata =
        BranchContentMetaData()
          ..addCustomMetadata('custom_string', 'abcdefg')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_integer', 0)
          ..addCustomMetadata('custom_double', 0.0)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c'])
          ..addCustomMetadata('custom_date_created', dateString)
          ..addCustomMetadata('\$og_image_width', 237)
          ..addCustomMetadata('\$og_image_height', 355)
          ..addCustomMetadata('\$og_image_url', imageURL);
    //--optional Custom Metadata
    /*
      ..contentSchema = BranchContentSchema.COMMERCE_PRODUCT
      ..price = 50.99
      ..currencyType = BranchCurrencyType.BRL
      ..quantity = 50
      ..sku = 'sku'
      ..productName = 'productName'
      ..productBrand = 'productBrand'
      ..productCategory = BranchProductCategory.ELECTRONICS
      ..productVariant = 'productVariant'
      ..condition = BranchCondition.NEW
      ..rating = 100
      ..ratingAverage = 50
      ..ratingMax = 100
      ..ratingCount = 2
      ..setAddress(
          street: 'street',
          city: 'city',
          region: 'ES',
          country: 'Brazil',
          postalCode: '99999-987')
      ..setLocation(31.4521685, -114.7352207);
      */

    final canonicalIdentifier = const Uuid().v4();
    buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch_$canonicalIdentifier',
      //parameter canonicalUrl
      //If your content lives both on the web and in the app, make sure you set its canonical URL
      // (i.e. the URL of this piece of content on the web) when building any BUO.
      // By doing so, we’ll attribute clicks on the links that you generate back to their original web page,
      // even if the user goes to the app instead of your website! This will help your SEO efforts.
      //canonicalUrl: 'https://flutter.dev',
      title: 'Flutter Branch Plugin - $dateString',
      imageUrl: imageURL,
      contentDescription: 'Flutter Branch Description - $dateString',
      contentMetadata: metadata,
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec:
          DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch,
    );

    //id = 155;

    lp =
        BranchLinkProperties(
            channel: 'share',
            feature: 'sharing',
            //parameter alias
            //Instead of our standard encoded short url, you can specify the vanity alias.
            // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
            // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.
            //alias: 'https://branch.io' //define link url,
            //alias: 'p/$canonicalIdentifier', //define link url,
            stage: 'new share',
            campaign: 'campaign',
            tags: ['one', 'two', 'three'],
          )
          ..addControlParam('\$uri_redirect_mode', '1')
          ..addControlParam('\$ios_nativelink', true)
          ..addControlParam('\$match_duration', 7200);
    //..addControlParam('\$always_deeplink', true);
    //..addControlParam('\$android_redirect_timeout', 750)
    //..addControlParam('referring_user_id', 'user_id');
    //..addControlParam('\$fallback_url', 'http')
    //..addControlParam(
    //    '\$fallback_url', 'https://flutter-branch-sdk.netlify.app/');
    //..addControlParam('\$ios_url', 'http');
    //..addControlParam(
    //    '\$android_url', 'https://flutter-branch-sdk.netlify.app/');

    eventStandard =
        BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART)
          //--optional Event data
          ..transactionID = '12344555'
          ..alias = 'StandardEventAlias'
          ..currency = BranchCurrencyType.BRL
          ..revenue = 1.5
          ..shipping = 10.2
          ..tax = 12.3
          ..coupon = 'test_coupon'
          ..affiliation = 'test_affiliation'
          ..eventDescription = 'Event_description'
          ..searchQuery = 'item 123'
          ..adType = BranchEventAdType.BANNER
          ..addCustomData(
            'Custom_Event_Property_Key1',
            'Custom_Event_Property_val1',
          )
          ..addCustomData(
            'Custom_Event_Property_Key2',
            'Custom_Event_Property_val2',
          );

    eventCustom =
        BranchEvent.customEvent('Custom_event')
          ..alias = 'CustomEventAlias'
          ..addCustomData(
            'Custom_Event_Property_Key1',
            'Custom_Event_Property_val1',
          )
          ..addCustomData(
            'Custom_Event_Property_Key2',
            'Custom_Event_Property_val2',
          );
  }

  void generateLink(BuildContext context) async {
    initDeepLinkData();
    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );
    if (response.success) {
      if (context.mounted) {
        showGeneratedLink(context, response.result);
      }
    } else {
      showSnackBar(
        message: 'Error : ${response.errorCode} - ${response.errorMessage}',
      );
    }
  }

  void showSnackBar({required String message, int duration = 2}) {
    scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: duration)),
    );
  }
  //

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
        ChangeNotifierProvider(create: (context) => HomeProvider()),

      ],

      child: Consumer2<TabViewProvider, OfflineStatusProvider>(
        builder: (context, provider, osp, _) {
          return Stack(
            children: [
              Scaffold(
                key: scaffoldMessengerKey,
                extendBody: true,
                body:
                    !osp.connected
                        ? OfflineScreen()
                        : provider.screens[provider.currentIndex],
                floatingActionButton:
                    provider.currentIndex == 3
                        ? null
                        : IconButton(
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

  void showGeneratedLink(BuildContext context, String url) async {
    initDeepLinkData();
    //FlutterBranchSdk.setRequestMetadata('key1_1', 'value1');
    //FlutterBranchSdk.setRequestMetadata('key2_1', 'value2');
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(12),
          height: 200,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text(
                  'Link created',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                url,
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 10),
              IntrinsicWidth(
                stepWidth: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: url));
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Center(child: Text('Copy link')),
                ),
              ),
              const SizedBox(height: 10),
              IntrinsicWidth(
                stepWidth: 300,
                child: ElevatedButton(
                  onPressed: () {
                    FlutterBranchSdk.handleDeepLink(url);
                    Navigator.pop(this.context);
                  },
                  child: const Center(child: Text('Handle deep link')),
                ),
              ),
            ],
          ),
        );
      },
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