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

class _JournalDetail1ScreenState extends State<JournalDetail1Screen>
    with SingleTickerProviderStateMixin {
  /// SVGs are deferred until after the route transition completes
  /// so they don't block the transition animation frames.
  bool _svgsReady = false;

  late final AnimationController _anim;

  // Background SVG: slides up + scales over the first 60%
  late final Animation<double> _bgSlide;
  late final Animation<double> _bgScale;

  // SVG cross-fade: quick swap in the first 25%
  late final Animation<double> _svgFadeOut;
  late final Animation<double> _svgFadeIn;

  // Content: slides up over 5%→50%
  late final Animation<Offset> _contentSlide;

  // Emoji: scales over 5%→35%
  late final Animation<double> _emojiScale;

  // Detail text + volume button: fades in over 40%→70%
  late final Animation<double> _detailOpacity;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final bgCurve = CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _bgSlide = Tween<double>(begin: 0.0, end: 1.0).animate(bgCurve);
    _bgScale = Tween<double>(begin: 1.0, end: 2.0).animate(bgCurve);

    final svgCurve = CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
    );
    _svgFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(svgCurve);
    _svgFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(svgCurve);

    _contentSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.18),
    ).animate(CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.05, 0.5, curve: Curves.easeOutCubic),
    ));

    _emojiScale = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.05, 0.35, curve: Curves.easeOut),
    ));

    _detailOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _waitForTransition();
    });
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
    // Parse SVGs now — route transition is finished so no jank
    setState(() => _svgsReady = true);
    // Give SVGs one frame to rasterize, then start the reveal
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
          _BackgroundLayer(
            screenHeight: screenHeight,
            anim: _anim,
            bgSlide: _bgSlide,
            bgScale: _bgScale,
            svgFadeOut: _svgFadeOut,
            svgFadeIn: _svgFadeIn,
            svgsReady: _svgsReady,
          ),
          _ContentLayer(
            screenHeight: screenHeight,
            contentSlide: _contentSlide,
            emojiScale: _emojiScale,
            detailOpacity: _detailOpacity,
            journal: widget.gratitudeJournal,
          ),
        ],
      ),
    );
  }
}

// ── Background ──────────────────────────────────────────────────────────────

class _BackgroundLayer extends StatelessWidget {
  final double screenHeight;
  final AnimationController anim;
  final Animation<double> bgSlide;
  final Animation<double> bgScale;
  final Animation<double> svgFadeOut;
  final Animation<double> svgFadeIn;
  final bool svgsReady;

  const _BackgroundLayer({
    required this.screenHeight,
    required this.anim,
    required this.bgSlide,
    required this.bgScale,
    required this.svgFadeOut,
    required this.svgFadeIn,
    required this.svgsReady,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Static PNGs — decoded async by Flutter, no main-thread cost
          RepaintBoundary(
            child: Image.asset(Assets.images.journalBottom1.path),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: RepaintBoundary(
              child: Image.asset(Assets.images.journalBottomleft.path),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: RepaintBoundary(
              child: Image.asset(Assets.images.journalBottomright.path),
            ),
          ),

          if (svgsReady)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: anim,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, -bgSlide.value * screenHeight * 0.7)
                      ..scale(bgScale.value),
                    alignment: Alignment.bottomCenter,
                    child: child,
                  );
                },
                // RepaintBoundary INSIDE the child: SVGs rasterize once,
                // then Transform + FadeTransition operate at the
                // compositing layer only — no SVG re-rasterization per tick.
                child: RepaintBoundary(
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        FadeTransition(
                          opacity: svgFadeOut,
                          child: SvgPicture.asset(
                            Assets.images.jouralDetailBottom,
                          ),
                        ),
                        FadeTransition(
                          opacity: svgFadeIn,
                          child: SvgPicture.asset(Assets.images.rainbow),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Content ─────────────────────────────────────────────────────────────────
//
// Uses *Transition widgets (SlideTransition, ScaleTransition, FadeTransition)
// which listen to their Animation directly — the widget itself never rebuilds
// during the animation, only its render object repaints.

class _ContentLayer extends StatelessWidget {
  final double screenHeight;
  final Animation<Offset> contentSlide;
  final Animation<double> emojiScale;
  final Animation<double> detailOpacity;
  final GratiudeJournalModel journal;

  const _ContentLayer({
    required this.screenHeight,
    required this.contentSlide,
    required this.emojiScale,
    required this.detailOpacity,
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
          const SizedBox(height: 30),

          // Top bar
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

          // Main content
          Flexible(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SlideTransition(
                  position: contentSlide,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: emojiScale,
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
                        Space.h20,

                        // Detail section: starts invisible, fades in mid-animation
                        FadeTransition(
                          opacity: detailOpacity,
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
                ),

                // Volume button
                Positioned(
                  bottom: 50,
                  child: FadeTransition(
                    opacity: detailOpacity,
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
