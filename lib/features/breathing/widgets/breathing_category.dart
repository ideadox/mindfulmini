import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/time_widget.dart';
import 'package:mindfulminis/common/widgets/views_widget.dart';

import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/features/breathing/providers/breathing_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

class BreathingCategory extends StatelessWidget {
  const BreathingCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return DefaultTabController(
      length: 3,
      child: Consumer<BreathingProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.breathing('category.title', fallback: 'Category'),
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.breathing(
                    'category.subtitle',
                    fallback:
                        'Breathing routines to support kids throughout the day',
                  ),
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              Space.h8,
              Container(
                height: 48,

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HexColor('#DCB8FF'),
                        HexColor('#DCB8FF').withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(300),
                  ),
                  tabs: [
                    Tab(
                      text: strings.breathing(
                        'category.tab_morning',
                        fallback: 'Morning',
                      ),
                    ),
                    Tab(
                      text: strings.breathing(
                        'category.tab_afternoon',
                        fallback: 'Afternoon',
                      ),
                    ),
                    Tab(
                      text: strings.breathing(
                        'category.tab_evening',
                        fallback: 'Evening',
                      ),
                    ),
                  ],
                ),
              ),
              CategoryWiseList(),
            ],
          );
        },
      ),
    );
  }
}

class CategoryWiseList extends StatelessWidget {
  const CategoryWiseList({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Consumer<BreathingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            height: 268,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.breathingSessions.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            height: 268,
            child: Center(
              child: Text(
                strings.breathing(
                  'category.empty_label',
                  fallback: 'No breathing exercises available',
                ),
                style: TextStyle(color: Colors.black45),
              ),
            ),
          );
        }

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 14),
          shrinkWrap: true,
          itemCount: provider.breathingSessions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 268,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
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
        );
      },
    );
  }
}
