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
        title: Text('App Setting'),
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
                  title: Text('Meditation Reminder'),
                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Divider(thickness: 0.4, color: AppColors.grey45),

                ListTile(
                  title: Text('Stay on track'),

                  subtitle: Text('Remember to never lose your streak'),
                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Divider(thickness: 0.4, color: AppColors.grey45),

                ListTile(
                  title: Text('Up to date'),
                  subtitle: Text('We’ll recommend you new routine'),

                  trailing: CupertinoSwitch(
                    activeTrackColor: AppColors.purple,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Divider(thickness: 0.4, color: AppColors.grey45),

                ListTile(
                  title: Text('Morning Activities'),
                  subtitle: Text('Get inspired by daily insights'),

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
