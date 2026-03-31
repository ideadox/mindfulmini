import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/collection_card_duration_badge.dart';
import '../../../../common/widgets/views_widget.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/app_formate.dart';
import '../../providers/home_provider.dart';

class BodyScanWidget extends StatelessWidget {
  const BodyScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingBodyScan) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.home('body_scan.title', fallback: 'Mini Body Scan'),
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.home(
                    'body_scan.subtitle',
                    fallback: 'Guided body scans to help kids relax and feel calm.',
                  ),
                  style: AppTextTheme.bodyTextStyle(
                    context,
                  ).bodyMedium?.copyWith(fontSize: 12),
                ),
              ),
              SizedBox(
                height: 268,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (provider.bodyScan.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                strings.home('body_scan.title', fallback: 'Mini Body Scan'),
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                strings.home(
                  'body_scan.subtitle',
                  fallback: 'Guided body scans to help kids relax and feel calm.',
                ),
                style: AppTextTheme.bodyTextStyle(
                  context,
                ).bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 268,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.bodyScan.length,
                separatorBuilder: (context, index) => Space.w16,
                itemBuilder: (context, index) {
                  final item = provider.bodyScan[index];
                  return InkWell(
                    onTap: () {
                      sl<GoRouter>().pushNamed(
                        PlayVisuals.routeName,
                        queryParameters: {
                          'collection': 'minibodyscans',
                          'id': item.id,
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          width: 177,
                          height: 268,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull(
                              '${ApiConstants.mediaBaseUrl}${item.cardImageFilename ?? ''}',
                            ),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: ViewsWidget(totalViews: item.viewCount),
                        ),
                        if (item.estimatedDuration.inMinutes > 0)
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: CollectionCardDurationBadge(
                              label: AppFormate.formatReadDuration(
                                item.estimatedDuration,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
