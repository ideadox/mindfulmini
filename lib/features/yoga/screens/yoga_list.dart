import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/play%20visuals/screen/play_visuals_copy.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/providers/yoga_provider.dart';
import 'package:mindfulminis/features/yoga/screens/widgets/yoga_list_shimmer_loader.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

class YogaList extends StatefulWidget {
  static String routeName = 'yoga-list';
  static String routePath = '/yoga-list';

  final String id;

  const YogaList({super.key, required this.id});

  @override
  State<YogaList> createState() => _YogaListState();
}

class _YogaListState extends State<YogaList> {
  @override
  void initState() {
    super.initState();
    // Fetch yoga content by ID
    Future.microtask(() {
      sl<YogaProvider>().fetchYogaContent(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YogaProvider>(
      builder: (context, yogaProvider, child) {
        if (yogaProvider.isContentLoading) {
          return Scaffold(body: YogaListShimmerLoader());
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space.h40,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            sl<GoRouter>().pop();
                          },
                          icon: Image.asset(Assets.icons.chevron.path),
                        ),
                        SizedBox(width: 48),
                      ],
                    ),
                    Center(
                      child: Text(
                        yogaProvider.selectedContent?.title ?? 'Spring Yoga',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (yogaProvider.contentError != null)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text('Error: ${yogaProvider.contentError}'),
                          ),
                        )
                      else
                        Column(
                          children: [
                            if (yogaProvider.selectedContent?.media != null &&
                                yogaProvider
                                        .selectedContent
                                        ?.media?['filename'] !=
                                    null)
                              Container(
                                width: double.infinity,
                                height: 250,
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      ApiConstants.mediaBaseUrl +
                                      (yogaProvider
                                              .selectedContent
                                              ?.media?['filename'] ??
                                          ''),
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        color: Colors.grey.shade200,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        color: Colors.grey.shade200,
                                        child: Icon(Icons.error),
                                      ),
                                ),
                              ),
                            VerticalStepperList(
                              yogaContent: yogaProvider.selectedContent!,
                            ),
                            Space.h40,
                            Space.h40,
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GradientButton(
              onPressed: () {
                sl<GoRouter>().pushNamed(
                  PlayVisualsCopy.routeName,
                  extra: yogaProvider.selectedContent,
                );
              },
              child: Center(
                child: Text(
                  'Let\'s Go',
                  style: AppTextTheme.mainButtonTextStyle(context).titleLarge,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class VerticalStepperList extends StatelessWidget {
  final YogaContentModel yogaContent;
  const VerticalStepperList({super.key, required this.yogaContent});

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 106 + 30;

    const int stepCount = 1;
    const int activeIndex = 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Space.h20,
              ListView.builder(
                itemCount: stepCount,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final isLast = index == stepCount - 1;
                  final bool isActive = index < activeIndex;
                  return Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child:
                            activeIndex == index
                                ? SvgPicture.asset(
                                  Assets.icons.currentLevelIcon,
                                )
                                : index < activeIndex
                                ? SvgPicture.asset(
                                  Assets.icons.completedLevelIcon,
                                )
                                : SvgPicture.asset(
                                  Assets.icons.upcomingLevelIcon,
                                ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: cardHeight - 30,
                          decoration: BoxDecoration(
                            gradient:
                                isActive
                                    ? LinearGradient(
                                      colors: [
                                        HexColor(
                                          '#6E40F9',
                                        ).withValues(alpha: 0.8),
                                        HexColor(
                                          '#A569FB',
                                        ).withValues(alpha: 0.8),
                                        HexColor(
                                          '#CE89FF',
                                        ).withValues(alpha: 0.8),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    )
                                    : null,
                            color: isActive ? null : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),
        Expanded(
          flex: 10,
          child: ListView.builder(
            itemCount: stepCount,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final isFirst = index == 0;
              final isLast = index == stepCount - 1;
              final bool isActive = index <= activeIndex;
              return SizedBox(
                height: cardHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stepper line and dot
                    // SizedBox(
                    //   width: stepperWidth,
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       // Stepper line
                    //       Positioned.fill(
                    //         top: isFirst ? cardHeight / 2 + 9 : 0,
                    //         bottom: isLast ? cardHeight / 2 + 9 : 0,
                    //         child: Align(
                    //           alignment: Alignment.center,
                    //           child: Container(
                    //             width: 4,
                    //             decoration: BoxDecoration(
                    //               gradient:
                    //                   isActive
                    //                       ? LinearGradient(
                    //                         colors: [
                    //                           HexColor(
                    //                             '#6E40F9',
                    //                           ).withValues(alpha: 0.8),
                    //                           HexColor(
                    //                             '#A569FB',
                    //                           ).withValues(alpha: 0.8),
                    //                           HexColor(
                    //                             '#CE89FF',
                    //                           ).withValues(alpha: 0.8),
                    //                         ],
                    //                         begin: Alignment.topCenter,
                    //                         end: Alignment.bottomCenter,
                    //                       )
                    //                       : null,
                    //               color: isActive ? null : Colors.grey.shade300,
                    //               borderRadius: BorderRadius.circular(12),
                    //             ),
                    //           ),
                    //         ),
                    //       ),

                    //       // Stepper Dot
                    //       Center(
                    //         child: Container(
                    //           width: 32,
                    //           height: 32,
                    //           decoration: BoxDecoration(shape: BoxShape.circle),
                    //           child:
                    //               activeIndex == index
                    //                   ? SvgPicture.asset(
                    //                     Assets.icons.currentLevelIcon,
                    //                   )
                    //                   : index < activeIndex
                    //                   ? SvgPicture.asset(
                    //                     Assets.icons.completedLevelIcon,
                    //                   )
                    //                   : SvgPicture.asset(
                    //                     Assets.icons.upcomingLevelIcon,
                    //                   ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(width: 12),

                    // Card content
                    Expanded(
                      child: Container(
                        height: 106 + 30,
                        margin: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              ApiConstants.mediaBaseUrl +
                                  yogaContent.media!['filename'].toString(),
                            ),
                            // AssetImage(Assets.dummy.springYogaCard.path),
                          ),
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
  }
}
