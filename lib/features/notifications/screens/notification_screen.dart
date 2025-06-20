
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/notifications/widgets/notification_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = 'notification-screen';
  static String routePath = '/notification-screen';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;

      // Clamp opacity between 0.0 and 1.0
      double newOpacity = (offset / 100).clamp(0.0, 1.0);

      if (newOpacity != _opacity) {
        setState(() {
          _opacity = newOpacity;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<List<int>> items = [
    [1],
    [1, 2, 3, 4, 5, 4, 3, 4, 3],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leadingWidth: 70,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, right: 2),
          child: CustomBackButton(hasBackground: true),
        ),

        title: Text('Notifications'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.icons.filterNotifcation),
          ),
          Space.w8,
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12),
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final Widget header = Row(
            children: [
              if (index == 0) CustomGradientText(text: 'Today', isBold: true),
              if (index != 0)
                Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              Space.w12,
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          );

          final List<Widget> notificationGroup =
              items[index].map((e) {
                return Column(
                  children: [NotificationCard(index: index), Space.h12],
                );
              }).toList();
          return Column(children: [header, Space.h12, ...notificationGroup]);
        },
      ),
    );
  }
}
