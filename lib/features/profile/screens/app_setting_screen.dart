import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_colors.dart';

class AppSettingScreen extends StatelessWidget {
  static String routeName = 'app-setting';
  static String routePath = '/app-setting';

  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var baseTheme = ThemeData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text('App Settings'),
      ),
      body: SingleChildScrollView(
        child: Theme(
          data: baseTheme.copyWith(
            listTileTheme: ListTileThemeData(
              subtitleTextStyle: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey45,
              ),
              titleTextStyle: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Meditation Reminder',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade200),

                ListTile(
                  title: Text(
                    'Stay on track',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),

                  subtitle: Text(
                    'Stay motivated and keep your streak going',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade200),

                ListTile(
                  title: Text(
                    'Up to date',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'We’ll recommend you new routine',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade200),

                ListTile(
                  title: Text(
                    'Morning Activities',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Get inspired by daily insights',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
