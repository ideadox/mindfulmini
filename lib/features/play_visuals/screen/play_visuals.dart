import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/play_visuals/models/play_visual_asset.dart';
import 'package:mindfulminis/features/play_visuals/provider/cms_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/chapter_wise_progress.dart';
import 'package:mindfulminis/features/play_visuals/widgets/audio_progress_bar.dart';
import 'package:mindfulminis/features/play_visuals/widgets/glass_panel.dart';
import 'package:mindfulminis/features/play_visuals/widgets/glass_styles.dart';
import 'package:mindfulminis/features/play_visuals/widgets/media_controls.dart';
import 'package:mindfulminis/features/play_visuals/widgets/play_visual_stack.dart';
import 'package:mindfulminis/features/play_visuals/widgets/top_bar.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/providers/yoga_play_visuals_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

class PlayVisuals extends StatefulWidget {
  static String routeName = 'play-visuals';
  static String routePath = '/play-visuals';
  final String? collection;
  final String? id;
  final YogaContentModel? yogaContentModel;

  const PlayVisuals({
    super.key,
    this.collection,
    this.id,
    this.yogaContentModel,
  });

  @override
  State<PlayVisuals> createState() => _PlayVisualsState();
}

class _PlayVisualsState extends State<PlayVisuals>
    with TickerProviderStateMixin {
  bool startAnimation = false;
  bool _hasMarkedViewed = false;

  late final AnimationController _lottiController;
  bool _showLottie = false;

  late final AnimationController _playPulseController;
  late final Animation<double> _playPulseAnimation;

  late final AnimationController _panelSnapController;

  @override
  void initState() {
    super.initState();
    _lottiController = AnimationController(vsync: this);

    _playPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _playPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _playPulseController, curve: Curves.easeInOut),
    );

    _panelSnapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      value: 1.0,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showLottie = true);
    });
  }

  @override
  void dispose() {
    _lottiController.dispose();
    _playPulseController.dispose();
    _panelSnapController.dispose();
    super.dispose();
  }

  // ── Panel drag ──

  static const double _panelDragSensitivity = 280;

  Animation<double> get _panelRevealAnimation =>
      startAnimation
          ? _panelSnapController
          : const AlwaysStoppedAnimation(1.0);

  void _onPanelVerticalDragUpdate(DragUpdateDetails details) {
    if (!startAnimation) return;
    final delta = details.primaryDelta! / _panelDragSensitivity;
    _panelSnapController.value =
        (_panelSnapController.value - delta).clamp(0.0, 1.0);
  }

  Future<void> _onPanelVerticalDragEnd(DragEndDetails details) async {
    if (!startAnimation) return;
    final v = details.velocity.pixelsPerSecond.dy;
    final t = _panelSnapController.value;
    final bool collapse;
    if (v > 900) {
      collapse = true;
    } else if (v < -900) {
      collapse = false;
    } else {
      collapse = t < 0.45;
    }
    await _snapPanelExpanded(!collapse);
  }

  Future<void> _snapPanelExpanded(bool expanded) async {
    final target = expanded ? 1.0 : 0.0;
    if ((_panelSnapController.value - target).abs() < 0.02) return;
    try {
      await _panelSnapController.animateTo(
        target,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    } catch (_) {}
    if (mounted) HapticFeedback.lightImpact();
  }

  // ── First-play trigger ──

  void _onFirstPlay() {
    setState(() => startAnimation = true);
    _playPulseController.stop();
    _playPulseController.value = 0;

    final contentId = widget.yogaContentModel?.id ?? widget.id;
    _tryMarkViewed(contentId: contentId);
  }

  void _tryMarkViewed({String? contentId, String? collection}) {
    if (_hasMarkedViewed) return;
    if (contentId == null || contentId.isEmpty) return;

    final effectiveCollection =
        collection ??
        widget.collection ??
        (widget.yogaContentModel != null ? 'yoga' : null);
    if (effectiveCollection == null) return;

    _hasMarkedViewed = true;

    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final profileId = profileProvider.userProfile?.id;
      if (profileId == null || profileId.isEmpty) return;

      sl<DiscoverData>()
          .markContentViewed(
            profileId: profileId,
            contentId: contentId,
            collection: effectiveCollection,
          )
          .catchError((e) {
            log('Error marking content viewed: $e');
          });
    } catch (e) {
      log('Error marking content viewed (sync): $e');
    }
  }

  // ── Helpers ──

  String _extractDescription(dynamic contentDescription) {
    try {
      if (contentDescription == null) return '';
      if (contentDescription is Map<String, dynamic>) {
        if (contentDescription['root'] != null &&
            contentDescription['root']['children'] != null) {
          final children = contentDescription['root']['children'] as List;
          if (children.isEmpty) return '';
          final firstParagraph = children.first;
          if (firstParagraph['children'] == null) return '';

          String description = '';
          for (var child in firstParagraph['children']) {
            if (child['type'] == 'text' && child['text'] != null) {
              String text = child['text']!
                  .replaceAll(RegExp(r'<break time="([\d.]+)s"\s*\/>'), '')
                  .trim();
              if (text.isNotEmpty) {
                description += '$text ';
              }
            }
          }
          return description.trim();
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    if (widget.yogaContentModel != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) sl<GoRouter>().pop(startAnimation);
        },
        child: ChangeNotifierProvider(
          create: (_) => YogaPlayVisualsProvider(
            yogaContent: widget.yogaContentModel!,
          ),
          child: Scaffold(
            body: Consumer<YogaPlayVisualsProvider>(
              builder: (context, yogaProvider, _) {
                if (!yogaProvider.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildDisplay(
                  still: PlayVisualAsset.tryParseMap(
                    widget.yogaContentModel?.stillVisualMap,
                  ),
                  playing: PlayVisualAsset.tryParseMap(
                    widget.yogaContentModel?.playingVisualMap,
                  ),
                  audioPlaying: yogaProvider.isPlaying,
                  titleSection: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.yogaContentModel!.title,
                        textAlign: TextAlign.center,
                        style: GlassStyles.titleStyle,
                      ),
                      Space.h4,
                      Text(
                        widget.yogaContentModel!.contentDescription?['en'] ??
                            '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GlassStyles.subtitleStyle,
                      ),
                      Space.h8,
                    ],
                  ),
                  activeContent: Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      return _YogaTextContent(
                        provider: provider,
                        textShadows: GlassStyles.textShadows,
                      );
                    },
                  ),
                  progressBuilder: (minimal) => Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      return AudioProgressBar(
                        currentPosition: provider.currentPosition,
                        totalDuration: provider.totalDuration,
                        onSeek: provider.seek,
                        minimalTransport: minimal,
                        isPlaying: provider.isPlaying,
                        onPlayPause: () {
                          if (!startAnimation) _onFirstPlay();
                          provider.playPause();
                        },
                      );
                    },
                  ),
                  controlBuilder: () => Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      return MediaControls(
                        isPlaying: provider.isPlaying,
                        sessionStarted: startAnimation,
                        playPulseAnimation: _playPulseAnimation,
                        repeatAsset: Assets.icons.repeatIcon,
                        back10Asset: Assets.icons.back10,
                        forward10Asset: Assets.icons.forward10,
                        heartAsset: Assets.icons.heartButton,
                        onPlayPause: () {
                          if (!startAnimation) _onFirstPlay();
                          provider.playPause();
                        },
                        onBack10: provider.seekBackward,
                        onForward10: provider.seekForward,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) sl<GoRouter>().pop(startAnimation);
      },
      child: ChangeNotifierProvider(
        create: (_) => CmsProvider(widget.collection ?? '', widget.id ?? ''),
        child: Scaffold(
          body: Consumer<CmsProvider>(
            builder: (context, p, _) {
              if (p.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (p.cms == null) {
                return const Center(child: Text('No data found'));
              }
              return _buildDisplay(
                still: PlayVisualAsset.stillFromCms(p.cms),
                playing: PlayVisualAsset.playingFromCms(p.cms),
                audioPlaying: p.isPlaying,
                titleSection: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      p.cms?.title ?? '',
                      textAlign: TextAlign.center,
                      style: GlassStyles.titleStyle,
                    ),
                    Space.h4,
                    Text(
                      _extractDescription(p.cms?.contentDescription),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GlassStyles.subtitleStyle,
                    ),
                    Space.h8,
                  ],
                ),
                activeContent: Consumer<CmsProvider>(
                  builder: (context, provider, _) {
                    return LyricLineBuilder(
                      segments: p.segments,
                      currentPosition: provider.currentPosition,
                      totalDuration: provider.totalDuration,
                      textStyle: GlassStyles.lyricStyle,
                    );
                  },
                ),
                progressBuilder: (minimal) => Consumer<CmsProvider>(
                  builder: (context, provider, _) {
                    return AudioProgressBar(
                      currentPosition: provider.currentPosition,
                      totalDuration: provider.totalDuration,
                      onSeek: provider.seek,
                      minimalTransport: minimal,
                      isPlaying: provider.isPlaying,
                      onPlayPause: () {
                        if (!startAnimation) _onFirstPlay();
                        provider.playPause();
                      },
                    );
                  },
                ),
                controlBuilder: () => Consumer<CmsProvider>(
                  builder: (context, provider, _) {
                    return MediaControls(
                      isPlaying: provider.isPlaying,
                      sessionStarted: startAnimation,
                      playPulseAnimation: _playPulseAnimation,
                      repeatAsset: Assets.icons.repeatIcon,
                      back10Asset: Assets.icons.back10,
                      forward10Asset: Assets.icons.forward10,
                      heartAsset: Assets.icons.heartButton,
                      onPlayPause: () {
                        if (!startAnimation) _onFirstPlay();
                        provider.playPause();
                      },
                      onBack10: provider.seekBackward,
                      onForward10: provider.seekForward,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Unified layout ──

  Widget _buildDisplay({
    required PlayVisualAsset? still,
    required PlayVisualAsset? playing,
    required bool audioPlaying,
    required Widget titleSection,
    required Widget activeContent,
    required Widget Function(bool minimal) progressBuilder,
    required Widget Function() controlBuilder,
  }) {
    final size = MediaQuery.sizeOf(context);
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. Full-screen motion / still background
          if (_showLottie)
            Positioned.fill(
              child: PlayVisualStack(
                still: still,
                playing: playing,
                sessionStarted: startAnimation,
                audioPlaying: audioPlaying,
              ),
            ),

          // 2. Light vignette — top only, bottom stays transparent for motion visibility
          _buildGradientOverlay(),

          // 3. Top bar
          PlayVisualsTopBar(
            safeTop: safeTop,
            onBack: () => sl<GoRouter>().pop(startAnimation),
            favouriteAsset: Assets.icons.heartButton,
          ),

          // 4. Glass bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _panelSnapController,
              builder: (context, _) {
                final minimal =
                    startAnimation && _panelSnapController.value < 0.22;
                return GlassBottomPanel(
                  safeBottom: safeBottom,
                  panelRevealAnimation: _panelRevealAnimation,
                  sessionStarted: startAnimation,
                  panelValue: _panelSnapController.value,
                  onDragUpdate: _onPanelVerticalDragUpdate,
                  onDragEnd: _onPanelVerticalDragEnd,
                  onGripTap: () => _snapPanelExpanded(true),
                  titleSection: titleSection,
                  activeContent: activeContent,
                  progressSection: progressBuilder(minimal),
                  controlSection: controlBuilder(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.18, 0.5, 0.85, 1.0],
            colors: [
              Colors.black.withValues(alpha: 0.35),
              Colors.black.withValues(alpha: 0.05),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.08),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Yoga text content ──

class _YogaTextContent extends StatelessWidget {
  const _YogaTextContent({
    required this.provider,
    required this.textShadows,
  });

  final YogaPlayVisualsProvider provider;
  final List<Shadow> textShadows;

  @override
  Widget build(BuildContext context) {
    if (provider.segments.isEmpty) return const SizedBox.shrink();

    final audioTotalMs = provider.totalDuration.inMilliseconds;
    if (audioTotalMs <= 0) return const SizedBox.shrink();

    final weights = provider.segments
        .map((s) => s.charCount.clamp(5, 99999).toDouble())
        .toList();
    final totalWeight = weights.fold<double>(0, (a, b) => a + b);

    final fraction =
        (provider.currentPosition.inMilliseconds / audioTotalMs).clamp(0.0, 1.0);
    double cumulative = 0;
    int segmentIndex = provider.segments.length - 1;
    for (int i = 0; i < provider.segments.length; i++) {
      cumulative += weights[i];
      if (fraction <= cumulative / totalWeight) {
        segmentIndex = i;
        break;
      }
    }

    if (segmentIndex >= provider.segments.length) {
      return Text(
        'Complete!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF8FF5C8),
          shadows: textShadows,
        ),
      );
    }

    final segment = provider.segments[segmentIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      child: RichText(
        key: ValueKey(segmentIndex),
        textAlign: TextAlign.center,
        text: TextSpan(
          children: segment.textSpans.map((span) {
            return TextSpan(
              text: span.text,
              style: span.textStyle.copyWith(
                fontSize: 20,
                color: Colors.white.withValues(alpha: 0.96),
                fontWeight: FontWeight.w600,
                height: 1.5,
                shadows: textShadows,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
