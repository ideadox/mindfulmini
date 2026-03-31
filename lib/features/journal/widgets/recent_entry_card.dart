import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/features/journal/models/gratiude_journal_model.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/utils/basic_function.dart';

class RecentEntryCard extends StatelessWidget {
  final VoidCallback onPressed;
  final GratiudeJournalModel gratiudeJournalModel;
  const RecentEntryCard({
    super.key,
    required this.onPressed,
    required this.gratiudeJournalModel,
  });

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.images.recentActivityBackgrocd.path),
          ),
        ),

        child: Row(
          children: [
            Space.w12,
            Container(
              alignment: Alignment.centerLeft,

              child: SvgPicture.asset(
                BasicFunction.getJounalEmoji(gratiudeJournalModel.emotion),
              ),
            ),
            Space.w20,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: HexColor('#FFEEF9'),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      gratiudeJournalModel.emotion,
                      style: TextStyle(color: HexColor('#FC09A3')),
                    ),
                  ),
                  Space.h8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(gratiudeJournalModel.date),
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      // Text(
                      //   '02:22 AM',
                      //   style: TextStyle(fontSize: 12, color: Colors.black87),
                      // ),
                      // SizedBox(width: 8),
                      // Text(
                      //   '•',
                      //   style: TextStyle(fontSize: 12, color: Colors.black87),
                      // ),
                      // SizedBox(width: 8),
                      Text(
                        '${BasicFunction.countWords(gratiudeJournalModel.emotionDescription)} ${strings.journal('detail.words_suffix', fallback: 'Words')}',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                  Space.h8,
                  Text(
                    '${strings.journal('detail.feeling_today_prefix', fallback: 'Feeling')} ${gratiudeJournalModel.emotion} ${strings.journal('detail.feeling_today_suffix', fallback: 'Today! 😊')}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
