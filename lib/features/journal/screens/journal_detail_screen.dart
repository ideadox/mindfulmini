import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/models/gratiude_journal_model.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/utils/basic_function.dart';
import '../providers/journal_provider.dart';

class JournalDetailScreen extends StatefulWidget {
  static String routeName = 'journal-detail1-screen';
  static String routePath = '/journal-detail1-screen:gratitudeId';
  final String gratitudeId;
  final GratiudeJournalModel gratitudeJournal;
  final JournalProvider journalProvider;

  const JournalDetailScreen({
    super.key,
    required this.gratitudeId,
    required this.gratitudeJournal,
    required this.journalProvider,
  });

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  /// Main block (header + emoji + summary): fade only — no slide/scale on
  /// SvgPicture (scale + slide force expensive raster work each frame).
  late final Animation<double> _contentFade;

  /// Journal body + chrome: slightly later so motion stays subtle.
  late final Animation<double> _detailFade;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.0, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _detailFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.22, 1.0, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _precacheBottomAssets();
      _waitForTransition();
    });
  }

  void _precacheBottomAssets() {
    if (!mounted) return;
    final c = context;
    precacheImage(AssetImage(Assets.images.journalBottom1.path), c);
    precacheImage(AssetImage(Assets.images.journalBottomleft.path), c);
    precacheImage(AssetImage(Assets.images.journalBottomright.path), c);
  }

  void _waitForTransition() {
    final route = ModalRoute.of(context);
    if (route?.animation == null || route!.animation!.isCompleted) {
      _onTransitionDone();
      return;
    }
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        route.animation!.removeStatusListener(listener);
        if (mounted) _onTransitionDone();
      }
    }
    route.animation!.addStatusListener(listener);
  }

  void _onTransitionDone() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundLayer(),
          _ContentLayer(
            screenHeight: screenHeight,
            contentFade: _contentFade,
            detailFade: _detailFade,
            journal: widget.gratitudeJournal,
          ),
        ],
      ),
    );
  }
}

// ── Background: static only. Animating Slide/Fade on large SvgPictures was
//    dominating the raster thread (see DevTools jank). Optional: replace
//    these SVGs with PNG/WebP exports at @2–3× for even lower cost.

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RepaintBoundary(
            child: Image.asset(
              Assets.images.journalBottom1.path,
              filterQuality: FilterQuality.low,
              gaplessPlayback: true,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: RepaintBoundary(
              child: Image.asset(
                Assets.images.journalBottomleft.path,
                filterQuality: FilterQuality.low,
                gaplessPlayback: true,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: RepaintBoundary(
              child: Image.asset(
                Assets.images.journalBottomright.path,
                filterQuality: FilterQuality.low,
                gaplessPlayback: true,
              ),
            ),
          ),

          // PERF A/B: large bottom SVGs (complex vectors). Commented out to
          // test frame time / jank — uncomment to restore full art.
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: RepaintBoundary(
          //     child: LayoutBuilder(
          //       builder: (context, constraints) {
          //         final w = constraints.maxWidth;
          //         final hDetail = w * 267 / 402;
          //         final hRainbow = w * 200 / 353;
          //         final h = hDetail > hRainbow ? hDetail : hRainbow;
          //         return SizedBox(
          //           width: w,
          //           height: h,
          //           child: Stack(
          //             alignment: Alignment.bottomCenter,
          //             clipBehavior: Clip.none,
          //             children: [
          //               Align(
          //                 alignment: Alignment.bottomCenter,
          //                 child: SizedBox(
          //                   width: w,
          //                   height: hDetail,
          //                   child: SvgPicture.asset(
          //                     Assets.images.jouralDetailBottom,
          //                     fit: BoxFit.fill,
          //                     alignment: Alignment.bottomCenter,
          //                     allowDrawingOutsideViewBox: false,
          //                   ),
          //                 ),
          //               ),
          //               Align(
          //                 alignment: Alignment.bottomCenter,
          //                 child: SizedBox(
          //                   width: w,
          //                   height: hRainbow,
          //                   child: SvgPicture.asset(
          //                     Assets.images.rainbow,
          //                     fit: BoxFit.fill,
          //                     alignment: Alignment.bottomCenter,
          //                     allowDrawingOutsideViewBox: false,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// ── Content ─────────────────────────────────────────────────────────────────

class _ContentLayer extends StatelessWidget {
  final double screenHeight;
  final Animation<double> contentFade;
  final Animation<double> detailFade;
  final GratiudeJournalModel journal;

  const _ContentLayer({
    required this.screenHeight,
    required this.contentFade,
    required this.detailFade,
    required this.journal,
  });

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    final countWord = BasicFunction.countWords(journal.emotionDescription);

    return SizedBox(
      height: screenHeight,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 65),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(hasBackground: true),
                    const SizedBox(width: 48),
                  ],
                ),
                Text(
                  strings.journal('detail.title', fallback: 'Journal Details'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          Flexible(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: contentFade,
                        child: Column(
                          children: [
                            RepaintBoundary(
                              child: Container(
                                width: 90,
                                height: 90,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                ),
                                child: SvgPicture.asset(
                                  BasicFunction.getJounalEmoji(journal.emotion),
                                  height: 90,
                                  width: 90,
                                ),
                              ),
                            ),
                            Space.h20,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: HexColor('#F5EFFF'),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                journal.emotion,
                                style: TextStyle(color: HexColor('#8E00FF')),
                              ),
                            ),
                            Space.h16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('MMM dd, yyyy').format(journal.date),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                const Text('•', style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 8),
                                Text(
                                  '$countWord ${strings.journal('detail.words_suffix', fallback: 'Words')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Space.h20,
                            Text(
                              '${strings.journal('detail.feeling_today_prefix', fallback: 'Feeling')} ${journal.emotion} ${strings.journal('detail.feeling_today_suffix', fallback: 'Today! 😊')}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Space.h20,
                      FadeTransition(
                        opacity: detailFade,
                        child: Column(
                          children: [
                            Divider(
                              thickness: 0.8,
                              color: AppColors.dividerColor,
                            ),
                            Space.h20,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                journal.emotionDescription,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            if (journal.accomplishments.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  journal.accomplishments.join('\n'),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 50,
                  child: FadeTransition(
                    opacity: detailFade,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.volume_up),
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
