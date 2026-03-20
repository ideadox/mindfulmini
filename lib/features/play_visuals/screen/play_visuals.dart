import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/play_visuals/models/play_visual_asset.dart';
import 'package:mindfulminis/features/play_visuals/provider/cms_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/chapter_wise_progress.dart';
import 'package:mindfulminis/features/play_visuals/widgets/play_visual_stack.dart';
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

  late AnimationController _lottiController;

  bool _showLottie = false;

  // Play button pulse animation (before first play)
  late AnimationController _playPulseController;
  late Animation<double> _playPulseAnimation;

  /// 1 = full chrome, 0 = minimal (progress + scrub only). Active after first play.
  late AnimationController _panelSnapController;

  /// Typography for the liquid-glass panel (light text + soft shadow on motion).
  List<Shadow> get _glassTextShadows => [
    Shadow(
      color: Colors.black.withValues(alpha: 0.55),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
    Shadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  TextStyle get _glassTitleStyle => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: Colors.white.withValues(alpha: 0.98),
    shadows: _glassTextShadows,
  );

  TextStyle get _glassSubtitleStyle => TextStyle(
    fontSize: 14,
    height: 1.35,
    color: Colors.white.withValues(alpha: 0.78),
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.45),
        blurRadius: 8,
        offset: const Offset(0, 1),
      ),
    ],
  );

  TextStyle get _glassLyricStyle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: Colors.white.withValues(alpha: 0.97),
    shadows: _glassTextShadows,
  );

  @override
  void initState() {
    super.initState();
    _lottiController = AnimationController(vsync: this);

    // Play button pulse
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

  @override
  void dispose() {
    _lottiController.dispose();
    _playPulseController.dispose();
    _panelSnapController.dispose();
    super.dispose();
  }

  static const double _panelDragSensitivity = 280;

  Animation<double> get _panelRevealAnimation =>
      startAnimation ? _panelSnapController : const AlwaysStoppedAnimation(1.0);

  void _onPanelVerticalDragUpdate(DragUpdateDetails details) {
    if (!startAnimation) return;
    final delta = details.primaryDelta! / _panelDragSensitivity;
    _panelSnapController.value = (_panelSnapController.value - delta).clamp(
      0.0,
      1.0,
    );
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

  /// Called once when the user first taps play
  void _onFirstPlay() {
    setState(() => startAnimation = true);
    _playPulseController.stop();
    _playPulseController.value = 0;

    final contentId = widget.yogaContentModel?.id ?? widget.id;
    _tryMarkViewed(contentId: contentId);
  }

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
              String text =
                  child['text']!
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.yogaContentModel != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) sl<GoRouter>().pop(startAnimation);
        },
        child: ChangeNotifierProvider(
          create:
              (context) => YogaPlayVisualsProvider(
                yogaContent: widget.yogaContentModel!,
              ),
          child: Scaffold(
            body: Consumer<YogaPlayVisualsProvider>(
              builder: (context, yogaProvider, _) {
                if (!yogaProvider.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildYogaDisplay(context, yogaProvider);
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
        create:
            (context) => CmsProvider(widget.collection ?? '', widget.id ?? ''),
        child: Scaffold(
          body: Consumer<CmsProvider>(
            builder: (context, p, _) {
              if (p.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (p.cms == null) {
                return const Center(child: Text('No data found'));
              }
              return _buildCmsDisplay(context, p);
            },
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  YOGA DISPLAY — position-synced text
  // ──────────────────────────────────────────────
  Widget _buildYogaDisplay(
    BuildContext context,
    YogaPlayVisualsProvider yogaProvider,
  ) {
    final size = MediaQuery.sizeOf(context);
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. Full-screen background — media-first still; motion/video while playing (loops, syncs pause).
          if (_showLottie)
            Positioned.fill(
              child: PlayVisualStack(
                still: PlayVisualAsset.tryParseMap(
                  widget.yogaContentModel?.stillVisualMap,
                ),
                playing: PlayVisualAsset.tryParseMap(
                  widget.yogaContentModel?.playingVisualMap,
                ),
                sessionStarted: startAnimation,
                audioPlaying: yogaProvider.isPlaying,
              ),
            ),

          // 2. Gradient overlay for readability
          _buildGradientOverlay(),

          // 3. Top bar
          _buildTopBar(safeTop),

          // 4. Glass bottom panel — rebuilds on drag so transport/minimal mode stays in sync
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _panelSnapController,
              builder: (context, _) {
                return _buildBottomPanel(
                  safeBottom: safeBottom,
                  titleSection: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.yogaContentModel!.title,
                        textAlign: TextAlign.center,
                        style: _glassTitleStyle,
                      ),
                      Space.h4,
                      Text(
                        widget.yogaContentModel!.contentDescription?['en'] ??
                            '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _glassSubtitleStyle,
                      ),
                      Space.h8,
                    ],
                  ),
                  activeContent: Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      return _buildYogaTextContent(provider);
                    },
                  ),
                  progressSection: Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      return _buildProgressSlider(
                        currentPosition: provider.currentPosition,
                        totalDuration: provider.totalDuration,
                        onSeek: (duration) => provider.seek(duration),
                        minimalTransport:
                            startAnimation && _panelSnapController.value < 0.22,
                        isPlaying: provider.isPlaying,
                        onPlayPause: () {
                          if (!startAnimation) _onFirstPlay();
                          provider.playPause();
                        },
                      );
                    },
                  ),
                  controlSection: Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      return _buildControlButtonStack(
                        isPlaying: provider.isPlaying,
                        onPlayPause: () {
                          if (!startAnimation) _onFirstPlay();
                          provider.playPause();
                        },
                        onBack10: () => provider.seekBackward(),
                        onForward10: () => provider.seekForward(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  CMS DISPLAY (stories, meditations, etc.)
  // ──────────────────────────────────────────────
  Widget _buildCmsDisplay(BuildContext context, CmsProvider p) {
    final size = MediaQuery.sizeOf(context);
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. Full-screen background — media-first still; motion/video while playing (loops, syncs pause).
          if (_showLottie)
            Positioned.fill(
              child: PlayVisualStack(
                still: PlayVisualAsset.stillFromCms(p.cms),
                playing: PlayVisualAsset.playingFromCms(p.cms),
                sessionStarted: startAnimation,
                audioPlaying: p.isPlaying,
              ),
            ),

          // 2. Gradient overlay for readability
          _buildGradientOverlay(),

          // 3. Top bar
          _buildTopBar(safeTop),

          // 4. Glass bottom panel — rebuilds on drag so transport/minimal mode stays in sync
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _panelSnapController,
              builder: (context, _) {
                return _buildBottomPanel(
                  safeBottom: safeBottom,
                  titleSection: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        p.cms?.title ?? '',
                        textAlign: TextAlign.center,
                        style: _glassTitleStyle,
                      ),
                      Space.h4,
                      Text(
                        _extractDescription(p.cms?.contentDescription),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _glassSubtitleStyle,
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
                        textStyle: _glassLyricStyle,
                      );
                    },
                  ),
                  progressSection: Consumer<CmsProvider>(
                    builder: (context, provider, _) {
                      return _buildProgressSlider(
                        currentPosition: provider.currentPosition,
                        totalDuration: provider.totalDuration,
                        onSeek: (duration) => provider.seek(duration),
                        minimalTransport:
                            startAnimation && _panelSnapController.value < 0.22,
                        isPlaying: provider.isPlaying,
                        onPlayPause: () {
                          if (!startAnimation) _onFirstPlay();
                          provider.playPause();
                        },
                      );
                    },
                  ),
                  controlSection: Consumer<CmsProvider>(
                    builder: (context, provider, _) {
                      return _buildControlButtonStack(
                        isPlaying: provider.isPlaying,
                        onPlayPause: () {
                          if (!startAnimation) _onFirstPlay();
                          provider.playPause();
                        },
                        onBack10: () => provider.seekBackward(),
                        onForward10: () => provider.seekForward(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  SHARED UI COMPONENTS
  // ──────────────────────────────────────────────

  /// Light vignette so the motion stays visible; readability is mostly from the glass panel.
  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.22, 0.5, 0.78, 1.0],
            colors: [
              Colors.black.withValues(alpha: 0.32),
              Colors.black.withValues(alpha: 0.03),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.05),
              Colors.black.withValues(alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }

  /// Top navigation bar with back + favourite buttons
  Widget _buildTopBar(double safeTop) {
    return Positioned(
      top: safeTop + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTopButton(
            onPressed: () => sl<GoRouter>().pop(startAnimation),
            icon: Icons.keyboard_arrow_down_rounded,
          ),
          _buildTopButton(
            onPressed: () {},
            iconAsset: Assets.icons.heartButton,
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton({
    VoidCallback? onPressed,
    IconData? icon,
    String? iconAsset,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.38),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon:
            icon != null
                ? Icon(
                  icon,
                  size: 24,
                  color: Colors.white.withValues(alpha: 0.95),
                )
                : SvgPicture.asset(
                  iconAsset!,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.92),
                    BlendMode.srcIn,
                  ),
                ),
      ),
    );
  }

  /// Liquid-glass bottom sheet. After playback starts, drag the grip down to minimize
  /// (progress + scrub only) or up to restore — smooth snap animation.
  Widget _buildBottomPanel({
    required double safeBottom,
    required Widget titleSection,
    required Widget activeContent,
    required Widget progressSection,
    required Widget controlSection,
  }) {
    const radius = Radius.circular(32);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8, 10, 8, safeBottom + 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: radius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                Colors.white.withValues(alpha: 0.06),
                Colors.white.withValues(alpha: 0.02),
                Colors.black.withValues(alpha: 0.18),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.28),
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPanelDragGrip(),
              SizeTransition(
                sizeFactor: _panelRevealAnimation,
                axis: Axis.vertical,
                axisAlignment: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedCrossFade(
                      firstChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: titleSection,
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100),
                          child: SizedBox(
                            width: double.infinity,
                            child: activeContent,
                          ),
                        ),
                      ),
                      crossFadeState:
                          startAnimation
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 400),
                      sizeCurve: Curves.easeOut,
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: startAnimation ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child:
                      startAnimation
                          ? progressSection
                          : const SizedBox.shrink(),
                ),
              ),
              SizeTransition(
                sizeFactor: _panelRevealAnimation,
                axis: Axis.vertical,
                axisAlignment: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Space.h4, controlSection],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelDragGrip() {
    final t = startAnimation ? _panelSnapController.value : 1.0;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: startAnimation ? _onPanelVerticalDragUpdate : null,
      onVerticalDragEnd: startAnimation ? _onPanelVerticalDragEnd : null,
      onTap: startAnimation && t < 0.22 ? () => _snapPanelExpanded(true) : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 10),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  /// Styled progress slider with millisecond precision for accurate seeking.
  /// When [minimalTransport] is true (panel minimized), shows a compact play/pause
  /// so playback can still be controlled without expanding.
  Widget _buildProgressSlider({
    required Duration currentPosition,
    required Duration totalDuration,
    required ValueChanged<Duration> onSeek,
    bool minimalTransport = false,
    bool isPlaying = false,
    VoidCallback? onPlayPause,
  }) {
    final progress =
        totalDuration.inMilliseconds > 0
            ? (currentPosition.inMilliseconds / totalDuration.inMilliseconds)
                .clamp(0.0, 1.0)
            : 0.0;

    final sliderBlock = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8,
              elevation: 4,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.28),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: progress,
            onChanged: (value) {
              final newDuration = Duration(
                milliseconds: (value * totalDuration.inMilliseconds).toInt(),
              );
              onSeek(newDuration);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(currentPosition),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.82),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.82),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (!minimalTransport || onPlayPause == null) {
      return sliderBlock;
    }

    // Collapsed panel: play/pause on the left, slider + times on the right
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPlayPause,
            customBorder: const CircleBorder(),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.28),
                  width: 0.5,
                ),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white.withValues(alpha: 0.95),
                size: 26,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: sliderBlock),
      ],
    );
  }

  /// Control buttons — Row layout so hit-testing always works
  Widget _buildControlButtonStack({
    required bool isPlaying,
    required VoidCallback onPlayPause,
    VoidCallback? onBack10,
    VoidCallback? onForward10,
  }) {
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Repeat
          AnimatedOpacity(
            opacity: startAnimation ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child:
                  startAnimation
                      ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _iconButton(Assets.icons.repeatIcon),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
          // Back 10
          AnimatedOpacity(
            opacity: startAnimation ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child:
                  startAnimation
                      ? Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _iconButton(
                          Assets.icons.back10,
                          onPressed: onBack10,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
          // Play / Pause (always visible)
          _buildPlayButton(isPlaying: isPlaying, onPressed: onPlayPause),
          // Forward 10
          AnimatedOpacity(
            opacity: startAnimation ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child:
                  startAnimation
                      ? Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: _iconButton(
                          Assets.icons.forward10,
                          onPressed: onForward10,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
          // Heart
          AnimatedOpacity(
            opacity: startAnimation ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child:
                  startAnimation
                      ? Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _iconButton(Assets.icons.heartButton),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// Gradient play button with pulse animation before first play
  Widget _buildPlayButton({
    required bool isPlaying,
    required VoidCallback onPressed,
  }) {
    return ScaleTransition(
      scale:
          !startAnimation
              ? _playPulseAnimation
              : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              key: ValueKey(isPlaying),
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  /// Small rounded icon button for control actions
  Widget _iconButton(String assetPath, {VoidCallback? onPressed}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.28),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed ?? () {},
        padding: EdgeInsets.zero,
        icon: SvgPicture.asset(
          assetPath,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            Colors.white.withValues(alpha: 0.92),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  /// Yoga text content — uses fraction-based sync so text respects audio pacing.
  /// Each segment is weighted by its character count: longer lines get a bigger
  /// slice of the audio timeline, which naturally accounts for pauses/spacing.
  Widget _buildYogaTextContent(YogaPlayVisualsProvider provider) {
    if (provider.segments.isEmpty) return const SizedBox.shrink();

    final audioTotalMs = provider.totalDuration.inMilliseconds;
    if (audioTotalMs <= 0) return const SizedBox.shrink();

    // ── Weight each segment by character count ──
    final weights =
        provider.segments.map((s) {
          return s.charCount.clamp(5, 99999).toDouble();
        }).toList();
    final totalWeight = weights.fold<double>(0, (a, b) => a + b);

    // ── Audio fraction → segment index ──
    final fraction = (provider.currentPosition.inMilliseconds / audioTotalMs)
        .clamp(0.0, 1.0);
    double cumulative = 0;
    int segmentIndex = provider.segments.length - 1; // default to last
    for (int i = 0; i < provider.segments.length; i++) {
      cumulative += weights[i];
      if (fraction <= cumulative / totalWeight) {
        segmentIndex = i;
        break;
      }
    }

    if (segmentIndex >= provider.segments.length) {
      return Text(
        'Complete! 🎉',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF8FF5C8),
          shadows: _glassTextShadows,
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
          children:
              segment.textSpans.map((span) {
                return TextSpan(
                  text: span.text,
                  style: span.textStyle.copyWith(
                    fontSize: 20,
                    color: Colors.white.withValues(alpha: 0.96),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    shadows: _glassTextShadows,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
