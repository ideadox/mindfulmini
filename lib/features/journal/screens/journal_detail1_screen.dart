import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/models/gratiude_journal_model.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/utiles/basic_function.dart';
import '../providers/journal_provider.dart';

class JournalDetail1Screen extends StatefulWidget {
  static String routeName = 'journal-detail1-screen';
  static String routePath = '/journal-detail1-screen:gratitudeId';
  final String gratitudeId;
  final GratiudeJournalModel gratitudeJournal;
  final JournalProvider journalProvider;

  const JournalDetail1Screen({
    super.key,
    required this.gratitudeId,
    required this.gratitudeJournal,
    required this.journalProvider,
  });

  @override
  State<JournalDetail1Screen> createState() => _JournalDetail1ScreenState();
}

class _JournalDetail1ScreenState extends State<JournalDetail1Screen> {
  bool _moveUp = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation after 800ms
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _moveUp = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: screenHeight,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Image.asset(Assets.images.journalBottom1.path),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(Assets.images.journalBottomleft.path),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(Assets.images.journalBottomright.path),
                ),

                AnimatedPositioned(
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.easeOutBack,
                  bottom: _moveUp ? screenHeight * 0.7 : 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: screenHeight,
                    alignment: Alignment.bottomCenter,
                    child: AnimatedScale(
                      scale: _moveUp ? 4 : 1.0,
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.easeOutBack,
                      child: SvgPicture.asset(
                        _moveUp
                            ? Assets.images.rainbow
                            : Assets.images.jouralDetailBottom,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ContentScreen(
            moveUp: _moveUp,
            screenHeight: screenHeight,
            gratiudeJournalModel: widget.gratitudeJournal,
            provider: widget.journalProvider,
          ),
        ],
      ),
    );
  }
}

class ContentScreen extends StatelessWidget {
  final bool moveUp;
  final double screenHeight;
  final GratiudeJournalModel gratiudeJournalModel;
  final JournalProvider provider;
  const ContentScreen({
    super.key,
    required this.moveUp,
    required this.screenHeight,
    required this.gratiudeJournalModel,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    int countWord = BasicFunction.countWords(
      gratiudeJournalModel.emotionDescription,
    );
    return SizedBox(
      height: screenHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(hasBackground: true),
                    SizedBox(width: 48),
                  ],
                ),
                Text(
                  'Journal Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          Builder(
            builder: (context) {
              return moveUp ? SizedBox(height: 130) : SizedBox(height: 100);
            },
          ),

          /// Main Content
          Flexible(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSlide(
                  offset:
                      moveUp
                          ? Offset(0, -0.2)
                          : Offset.zero, // move up slightly
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        AnimatedScale(
                          scale: moveUp ? 1.2 : 1.0,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade300,
                            ),
                            child: SvgPicture.asset(
                              BasicFunction.getJounalEmoji(
                                gratiudeJournalModel.emotion,
                              ),
                              height: 90,
                              width: 90,
                            ),
                          ),
                        ),

                        // Rest of content
                        Space.h20,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor('#F5EFFF'),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            gratiudeJournalModel.emotion,
                            style: TextStyle(color: HexColor('#8E00FF')),
                          ),
                        ),
                        Space.h16,

                        /// Time info with dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(gratiudeJournalModel.date),
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 8),
                            Text('•', style: TextStyle(fontSize: 12)),
                            // SizedBox(width: 8),
                            // Text('02:22 AM', style: TextStyle(fontSize: 12)),
                            // SizedBox(width: 8),
                            // Text('•', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 8),
                            Text(
                              '$countWord Words',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),

                        Space.h20,
                        Text(
                          'Feeling ${gratiudeJournalModel.emotion} Today! 😊',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Space.h20,
                        Builder(
                          builder: (context) {
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 600),
                              child:
                                  !moveUp
                                      ? SizedBox.shrink()
                                      : Column(
                                        children: [
                                          Divider(
                                            thickness: 0.8,
                                            color: AppColors.dividerColor,
                                          ),
                                          Space.h20,
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              gratiudeJournalModel
                                                  .emotionDescription,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              gratiudeJournalModel
                                                  .accomplishments
                                                  .join('\n'),
                                            ),
                                          ),
                                        ],
                                      ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    child:
                        !moveUp
                            ? SizedBox.shrink()
                            : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.volume_up),
                                color: Colors.black,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
