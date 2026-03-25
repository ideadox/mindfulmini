import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/library/providers/library_provider.dart';
import 'package:mindfulminis/features/library/widgets/myfavorites.dart';
import 'package:mindfulminis/features/library/widgets/recent_watched.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  static String routeName = 'library-screen';
  static String routePath = '/library-screen';

  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final profileId =
        Provider.of<ProfileProvider>(context, listen: false).userProfile?.id;
    if (profileId == null || profileId.isEmpty) return;

    final libraryProvider = sl<LibraryProvider>();
    libraryProvider.loadFavorites(profileId);
    libraryProvider.loadRecentlyViewed(profileId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const CustomBackButton(),
          title: const Text('Library'),
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
                  padding: const EdgeInsets.all(3),
                  tabs: const [
                    Tab(text: 'My Favorites'),
                    Tab(text: 'Recent Viewed'),
                  ],
                ),
              ),
              Space.h20,
              Space.h12,
              const Expanded(
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
