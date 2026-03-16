import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/play_visuals/provider/cms_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/chapter_wise_progress.dart';
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

  late AnimationController _lottiController;

  bool _showLottie = false;

  // Play button pulse animation (before first play)
  late AnimationController _playPulseController;
  late Animation<double> _playPulseAnimation;

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

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showLottie = true);
    });
  }

  @override
  void dispose() {
    _lottiController.dispose();
    _playPulseController.dispose();
    super.dispose();
  }

  /// Called once when the user first taps play
  void _onFirstPlay() {
    setState(() => startAnimation = true);
    _playPulseController.stop();
    _playPulseController.value = 0;
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.yogaContentModel != null) {
      return ChangeNotifierProvider(
        create: (context) =>
                YogaPlayVisualsProvider(yogaContent: widget.yogaContentModel!),
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
      );
    }

    return ChangeNotifierProvider(
      create: (context) =>
          CmsProvider(widget.collection ?? '', widget.id ?? ''),
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
          // 1. Full-screen background image (no bottom gap)
          if (_showLottie)
            Positioned.fill(
              child: Hero(
                tag: 'audio',
                child: CachedNetworkImage(
                  imageUrl: ApiConstants.mediaBaseUrl +
                      (widget.yogaContentModel?.media?['filename'] ?? ''),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

          // 2. Gradient overlay for readability
          _buildGradientOverlay(),

          // 3. Top bar
          _buildTopBar(safeTop),

          // 4. Glassmorphic bottom panel — text lives here now
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPanel(
              safeBottom: safeBottom,
              titleSection: Column(
              children: [
                        Text(
                          widget.yogaContentModel!.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                          ),
                        ),
                  Space.h4,
                        Text(
                    widget.yogaContentModel!.contentDescription?['en'] ?? '',
                          textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
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
          // 1. Full-screen background image (no bottom gap)
          if (_showLottie && p.cms?.media?.filename != null)
            Positioned.fill(
              child: Hero(
                tag: 'audio',
                child: CachedNetworkImage(
                  imageUrl:
                      '${ApiConstants.mediaBaseUrl}${p.cms!.media!.filename}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

          // 2. Gradient overlay for readability
          _buildGradientOverlay(),

          // 3. Top bar
          _buildTopBar(safeTop),

          // 4. Glassmorphic bottom panel — text lives here now
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPanel(
              safeBottom: safeBottom,
              titleSection: Column(
              children: [
                  Text(
                    p.cms?.title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Space.h4,
                  Text(
                    _extractDescription(p.cms?.contentDescription),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
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
                    );
                  },
                ),
              progressSection: Consumer<CmsProvider>(
                builder: (context, provider, _) {
                  return _buildProgressSlider(
                    currentPosition: provider.currentPosition,
                    totalDuration: provider.totalDuration,
                    onSeek: (duration) => provider.seek(duration),
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
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  SHARED UI COMPONENTS
  // ──────────────────────────────────────────────

  /// Dark gradient overlay on top of the image for better text contrast
  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
                        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            colors: [
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha: 0.05),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.15),
              Colors.black.withValues(alpha: 0.55),
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
            onPressed: () => sl<GoRouter>().pop(),
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
        color: Colors.white.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
                              ),
                          ],
                        ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: icon != null
            ? Icon(icon, size: 24, color: Colors.black87)
            : SvgPicture.asset(iconAsset!, width: 20, height: 20),
                        ),
    );
  }

  /// Glassmorphic bottom panel with title/active-content, progress bar, and controls.
  /// When playing starts, [titleSection] cross-fades into [activeContent] (lyrics/yoga text).
  Widget _buildBottomPanel({
    required double safeBottom,
    required Widget titleSection,
    required Widget activeContent,
    required Widget progressSection,
    required Widget controlSection,
  }) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 12, 8, safeBottom + 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
                        ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title ↔ active content swap
              AnimatedCrossFade(
                firstChild: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: titleSection,
                ),
                secondChild: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: activeContent,
                  ),
                ),
                crossFadeState: startAnimation
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 400),
                sizeCurve: Curves.easeOut,
              ),
              // Progress bar — fades in when playing
              AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: startAnimation
                      ? progressSection
                      : const SizedBox.shrink(),
                ),
              ),
              Space.h4,
              // Control buttons
              controlSection,
                    ],
                  ),
                ),
                        ),
    );
  }

  /// Styled progress slider with millisecond precision for accurate seeking
  Widget _buildProgressSlider({
    required Duration currentPosition,
    required Duration totalDuration,
    required ValueChanged<Duration> onSeek,
  }) {
    final progress = totalDuration.inMilliseconds > 0
        ? (currentPosition.inMilliseconds / totalDuration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    return Column(
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
            inactiveTrackColor: AppColors.purple.withValues(alpha: 0.2),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: progress,
                                onChanged: (value) {
              final newDuration = Duration(
                milliseconds:
                    (value * totalDuration.inMilliseconds).toInt(),
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
                  color: Colors.grey.shade600,
                ),
                                  ),
                                  Text(
                _formatDuration(totalDuration),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                                  ),
                              ),
                          ],
                        ),
                      ),
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
              child: startAnimation
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
              child: startAnimation
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
              child: startAnimation
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
              child: startAnimation
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
      scale: !startAnimation
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
        color: AppColors.purple.withValues(alpha: 0.12),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.08),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
      onPressed: onPressed ?? () {},
        padding: EdgeInsets.zero,
        icon: SvgPicture.asset(assetPath, width: 20, height: 20),
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
    final weights = provider.segments.map((s) {
      return s.charCount.clamp(5, 99999).toDouble();
    }).toList();
    final totalWeight = weights.fold<double>(0, (a, b) => a + b);

    // ── Audio fraction → segment index ──
    final fraction =
        (provider.currentPosition.inMilliseconds / audioTotalMs).clamp(0.0, 1.0);
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
      return const Text(
        'Complete! 🎉',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.green,
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
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
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
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.5,
                shadows: [], // clear any shadows — light background
          ),
        );
          }).toList(),
        ),
      ),
    );
  }

}
