import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';

import '../widgets/subscription_sheet.dart';

class ManageSubscription extends StatelessWidget {
  static String routeName = 'manage-subs';
  static String routePath = '/manage-subs';

  const ManageSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text('Manage subcription'),
      ),
      body: Column(
        children: [
          Space.h40,
          ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return SubscriptionSheet();
                },
              );
            },
            title: Text('Choose a plan'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(color: Colors.grey.shade300),
          ),
          ListTile(
            title: Text('Restore a plan'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
