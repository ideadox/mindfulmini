import 'package:flutter/material.dart';
import 'package:mindfulminis/common/providers/speech_provider.dart';
import 'package:mindfulminis/common/widgets/common_speech_textfield.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/journal/providers/create_journal_provider.dart';
import 'package:mindfulminis/features/journal/widgets/feeling_container_widget.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../profile/providers/profile_provider.dart';

class CreateJournalScreen extends StatefulWidget {
  static String routeName = 'create-journal-screen';
  static String routePath = '/create-journal-screen/:activityId';
  final String activityId;

  const CreateJournalScreen({super.key, required this.activityId});

  @override
  State<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  late SpeechProvider _provider1;
  late SpeechProvider _provider2;

  @override
  void initState() {
    super.initState();
    _provider1 = SpeechProvider();
    _provider2 = SpeechProvider();
  }

  @override
  void dispose() {
    _provider1.dispose();
    _provider2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileId = context.read<ProfileProvider>().userProfile.id;

    return GradientScaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ChangeNotifierProvider(
          create: (context) => CreateJournalProvider(profileId),
          child: Consumer<CreateJournalProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [CustomBackButton(), SizedBox(width: 48)],
                      ),

                      Center(
                        child: Text(
                          'Thu, Feb 6',
                          style: AppTextTheme.titleTextTheme(
                            context,
                          ).titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How are you feeling today?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Space.h20,
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FeelingContainerWidget(
                                    title: 'Amazing',
                                    icon: Assets.icons.amazingEmoji,
                                    selected:
                                        provider.slectedFeeling == 'Amazing',
                                    makeGrey: provider.slectedFeeling != null,
                                    onPressed: () {
                                      provider.onChangeFeeling('Amazing');
                                    },
                                  ),
                                  FeelingContainerWidget(
                                    title: 'Happy',
                                    icon: Assets.icons.happy,
                                    selected:
                                        provider.slectedFeeling == 'Happy',
                                    makeGrey: provider.slectedFeeling != null,
                                    onPressed: () {
                                      provider.onChangeFeeling('Happy');
                                    },
                                  ),
                                  FeelingContainerWidget(
                                    title: 'Confused',
                                    icon: Assets.icons.confushedEmoji,
                                    makeGrey: provider.slectedFeeling != null,
                                    selected:
                                        provider.slectedFeeling == 'Confused',

                                    onPressed: () {
                                      provider.onChangeFeeling('Confused');
                                    },
                                  ),
                                  FeelingContainerWidget(
                                    title: 'Sad',
                                    icon: Assets.icons.sadEmoji,
                                    makeGrey: provider.slectedFeeling != null,
                                    selected: provider.slectedFeeling == 'Sad',

                                    onPressed: () {
                                      provider.onChangeFeeling('Sad');
                                    },
                                  ),
                                  FeelingContainerWidget(
                                    title: 'Upset',
                                    icon: Assets.icons.upsetEmoji,
                                    makeGrey: provider.slectedFeeling != null,
                                    selected:
                                        provider.slectedFeeling == 'Upset',

                                    onPressed: () {
                                      provider.onChangeFeeling('Upset');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Space.h40,
                            Text(
                              'Today I am grateful for?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Space.h20,
                            CommonSpeechTextfield(
                              maxLines: 6,
                              minLines: 6,
                              hintText: 'Playing with my best friend...',
                              speechProvider: _provider1,
                            ),

                            Space.h40,
                            Text(
                              "3 things I'll accomplish today",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Space.h20,
                            CommonSpeechTextfield(
                              maxLines: 6,
                              minLines: 6,
                              hintText: 'I will finish my coloring or drawing.',
                              speechProvider: _provider2,
                            ),
                            Space.h40,

                            GradientButton(
                              onPressed:
                                  provider.loading
                                      ? null
                                      : () {
                                        provider.createJournal(
                                          _provider1.textController.text,
                                          _provider2.textController.text,
                                          widget.activityId,
                                        );
                                      },
                              child: Center(
                                child:
                                    provider.loading
                                        ? CircularProgressIndicator()
                                        : Text(
                                          'Done',

                                          style:
                                              AppTextTheme.mainButtonTextStyle(
                                                context,
                                              ).titleLarge,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
