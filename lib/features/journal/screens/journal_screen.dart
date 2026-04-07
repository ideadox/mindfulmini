import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/journal/providers/journal_provider.dart';
import 'package:mindfulminis/features/journal/widgets/custom_month_calender.dart';
import 'package:mindfulminis/features/journal/widgets/recent_entry_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../profile/providers/profile_provider.dart';
import 'journal_detail_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        if (profileProvider.loading || profileProvider.userProfile == null) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final profileId = profileProvider.userProfile!.id;

        String getGreeting() {
          final hour = DateTime.now().hour;

          if (hour >= 5 && hour < 12) {
            return 'Good Morning';
          } else if (hour >= 12 && hour < 17) {
            return 'Good Afternoon';
          } else if (hour >= 17 && hour < 21) {
            return 'Good Evening';
          } else {
            return 'Good Night';
          }
        }

        return ChangeNotifierProvider(
          create:
              (context) => JournalProvider(profileId)..getGratitudeJournals(),
          child: Scaffold(
            body: Consumer<JournalProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.getGratitudeJournals();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 440,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    Assets.images.journalTopBackground.path,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: kToolbarHeight + 8,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white54,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(Assets.icons.morningIcon),
                                    Space.w12,

                                    Text(
                                      getGreeting(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: Column(
                                children: [
                                  Text(
                                    'Gratitude Journaling',
                                    textAlign: TextAlign.center,
                                    style: AppTextTheme.titleTextTheme(
                                      context,
                                    ).titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Space.h4,
                                  Text(
                                    'A Daily Practice of Thankfulness',
                                    textAlign: TextAlign.center,
                                    style: AppTextTheme.bodyTextStyle(
                                      context,
                                    ).bodyMedium?.copyWith(fontSize: 14),
                                  ),
                                  Space.h4,
                                  if (!provider.hasJournalForToday)
                                    SizedBox(
                                      width: 173,
                                      height: 48,
                                      child: GradientButton(
                                        onPressed: () {
                                          provider.navigateToCreateJournal();
                                          return;
                                        },
                                        child: Center(
                                          child: Text(
                                            'Start Journaling',
                                            style:
                                                AppTextTheme.mainButtonTextStyle(
                                                  context,
                                                ).titleLarge?.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              if (provider.gratitudeJournals.isNotEmpty) ...[
                                if (!provider.hasJournalForToday)
                                  Row(
                                    children: [
                                      Text(
                                        'Recent Entries',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                Space.h12,
                                RecentEntryCard(
                                  gratiudeJournalModel:
                                      provider.gratitudeJournals.last,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return JournalDetailScreen(
                                            gratitudeId:
                                                provider
                                                    .gratitudeJournals
                                                    .last
                                                    .id,
                                            gratitudeJournal:
                                                provider.gratitudeJournals.last,
                                            journalProvider: provider,
                                          );
                                        },
                                      ),
                                    );
                                    return;
                                  },
                                ),
                              ],
                              Space.h16,

                              CustomMonthCalender(provider: provider),
                            ],
                          ),
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
      },
    );
  }
}
