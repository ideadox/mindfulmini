import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/library/widgets/myfavorites.dart';
import 'package:mindfulminis/features/library/widgets/recent_watched.dart';

class LibraryScreen extends StatelessWidget {
  static String routeName = 'library-screen';
  static String routePath = '/library-screen';

  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: CustomBackButton(),
          title: Text('Library'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Space.h8,
              Container(
                height: 48,

                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  splashBorderRadius: BorderRadius.circular(300),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),

                  unselectedLabelStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  padding: EdgeInsets.all(3),
                  tabs: [Tab(text: 'My Favorites'), Tab(text: 'Recent Viewed')],
                ),
              ),
              Space.h20,
              Space.h12,

              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [Myfavorites(), RecentWatched()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
