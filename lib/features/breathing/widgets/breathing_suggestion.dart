import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/breathing/providers/breathing_provider.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/time_widget.dart';
import '../../../common/widgets/views_widget.dart';
import '../../../core/api_constants.dart';
import '../../play_visuals/screen/play_visuals.dart';

class BreathingSuggestion extends StatelessWidget {
  const BreathingSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Consumer<BreathingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.breathing(
                    'suggestion.title',
                    fallback: 'Suggested For You',
                  ),
                  style: AppTextTheme.titleTextTheme(
                    context,
                  ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.breathing(
                    'suggestion.subtitle',
                    fallback:
                        'Short breathing exercises to help kids slow down and feel peaceful',
                  ),
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              SizedBox(
                height: 268,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (provider.breathingSessions.isEmpty) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.breathing(
                    'suggestion.title',
                    fallback: 'Suggested For You',
                  ),
                  style: AppTextTheme.titleTextTheme(
                    context,
                  ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.breathing(
                    'suggestion.subtitle',
                    fallback:
                        'Short breathing exercises to help kids slow down and feel peaceful',
                  ),
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              SizedBox(
                height: 268,
                child: Center(
                  child: Text(
                    strings.breathing(
                      'suggestion.empty_label',
                      fallback: 'No breathing exercises available',
                    ),
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                strings.breathing(
                  'suggestion.title',
                  fallback: 'Suggested For You',
                ),
                style: AppTextTheme.titleTextTheme(
                  context,
                ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                strings.breathing(
                  'suggestion.subtitle',
                  fallback:
                      'Short breathing exercises to help kids slow down and feel peaceful',
                ),
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 268,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.breathingSessions.length,
                separatorBuilder: (context, index) {
                  return Space.w16;
                },
                itemBuilder: (context, index) {
                  final breathingItem = provider.breathingSessions[index];
                  return InkWell(
                    onTap: () {
                      sl<GoRouter>().pushNamed(
                        PlayVisuals.routeName,
                        queryParameters: {
                          'collection': 'breaths',
                          'id': breathingItem.id,
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 216,
                          height: 268,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull(
                              '${ApiConstants.mediaBaseUrl}${breathingItem.cardImageFilename ?? ''}',
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
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: TimeWidget(
                            totalTime: 5,
                          ),
                        ),

                        Positioned(
                          right: 10,
                          top: 10,
                          child: ViewsWidget(
                            totalViews: breathingItem.viewCount ?? 0,
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
