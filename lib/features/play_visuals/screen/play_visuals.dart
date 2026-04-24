import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/library/providers/library_provider.dart';
import 'package:mindfulminis/features/play_visuals/models/play_visual_asset.dart';
import 'package:mindfulminis/features/play_visuals/provider/cms_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/chapter_wise_progress.dart';
import 'package:mindfulminis/features/play_visuals/widgets/audio_progress_bar.dart';
import 'package:mindfulminis/features/play_visuals/widgets/media_controls.dart';
import 'package:mindfulminis/features/play_visuals/widgets/play_visual_stack.dart';
import 'package:mindfulminis/features/play_visuals/widgets/top_bar.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
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
  bool _showBackground = false;

  bool _isDarkBackground = false;
  String? _lastAnalyzedUrl;

  // Adaptive text colors based on background brightness
  Color get _titleColor =>
      _isDarkBackground ? Colors.white : Colors.black;
  Color get _subtitleColor => _isDarkBackground
      ? Colors.white.withValues(alpha: 0.65)
      : Colors.black.withValues(alpha: 0.8);
  Color get _lyricColor =>
      _isDarkBackground
          ? Colors.white.withValues(alpha: 0.9)
          : Colors.black.withValues(alpha: 0.8);

  late final AnimationController _shimmerController;
  late final AnimationController _playPulseController;
  late final Animation<double> _playPulseAnimation;

  bool get _isYoga => widget.yogaContentModel != null;

  String get _contentId =>
      widget.yogaContentModel?.id ?? widget.id ?? '';

  String get _effectiveCollection =>
      widget.collection ?? (_isYoga ? 'yoga' : '');

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _playPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _playPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _playPulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showBackground = true);
    });

    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    if (_contentId.isEmpty) return;
    try {
      final profileId = Provider.of<ProfileProvider>(context, listen: false)
          .userProfile?.id;
      if (profileId == null || profileId.isEmpty) return;
      sl<LibraryProvider>().checkFavoriteStatus(
        profileId: profileId,
        contentId: _contentId,
      );
    } catch (e) {
      log('Error checking favorite status: $e');
    }
  }

  void _handleToggleFavorite() {
    if (_contentId.isEmpty || _effectiveCollection.isEmpty) return;
    try {
      final profileId = Provider.of<ProfileProvider>(context, listen: false)
          .userProfile?.id;
      if (profileId == null || profileId.isEmpty) return;
      sl<LibraryProvider>().toggleFavorite(
        profileId: profileId,
        contentId: _contentId,
        collection: _effectiveCollection,
      );
    } catch (e) {
      log('Error toggling favorite: $e');
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _playPulseController.dispose();
    super.dispose();
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
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final profileId = profileProvider.userProfile?.id;
      if (profileId == null || profileId.isEmpty) return;

      sl<DiscoverData>()
          .markContentViewed(
            profileId: profileId,
            contentId: contentId,
            collection: effectiveCollection,
          )
          .catchError((e) => log('Error marking content viewed: $e'));
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
              if (text.isNotEmpty) description += '$text ';
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

  // ── Background brightness detection ──

  void _analyzeBackgroundColor(PlayVisualAsset? still) {
    final url = still?.url;
    if (url == null || url == _lastAnalyzedUrl) return;
    _lastAnalyzedUrl = url;
    if (still!.isVideo) return;
    _computeImageBrightness(url);
  }

  Future<void> _computeImageBrightness(String url) async {
    try {
      final provider = ResizeImage(
        CachedNetworkImageProvider(url),
        width: 50,
        height: 50,
      );
      final completer = Completer<ui.Image>();
      final stream = provider.resolve(ImageConfiguration.empty);
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          if (!completer.isCompleted) completer.complete(info.image);
          stream.removeListener(listener);
        },
        onError: (error, _) {
          if (!completer.isCompleted) completer.completeError(error);
          stream.removeListener(listener);
        },
      );
      stream.addListener(listener);

      final image = await completer.future;
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      if (data == null || !mounted) return;

      final bytes = data.buffer.asUint8List();
      double totalLum = 0;
      int count = 0;
      for (int i = 0; i + 3 < bytes.length; i += 4) {
        totalLum += 0.2126 * bytes[i] / 255 +
            0.7152 * bytes[i + 1] / 255 +
            0.0722 * bytes[i + 2] / 255;
        count++;
      }

      if (count == 0 || !mounted) return;
      setState(() => _isDarkBackground = (totalLum / count) < 0.5);
    } catch (e) {
      log('Background brightness analysis failed: $e');
    }
  }

  // ── Full-page shimmer matching the play_visuals layout ──

  Widget _buildShimmer() {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, _) {
        final position = _shimmerController.value;
        return ColoredBox(
          color: Colors.white,
          child: Stack(
            children: [
              // Top bar: back button + favourite
              Positioned(
                top: safeTop + 12,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(position, 40, 40, isCircle: true),
                    _shimmerBox(position, 40, 40, isCircle: true),
                  ],
                ),
              ),

              // Center image placeholder
              Center(
                child: _shimmerBox(position, 300, 430, borderRadius: 24),
              ),

              // Bottom section: title + play button
              Positioned(
                left: 0,
                right: 0,
                bottom: safeBottom + 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title placeholder
                    _shimmerBox(position, 180, 22),
                    const SizedBox(height: 8),
                    // Subtitle placeholder
                    _shimmerBox(position, 240, 14),
                    const SizedBox(height: 28),
                    // Play button placeholder
                    _shimmerBox(position, 64, 64, isCircle: true),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(
    double position,
    double width,
    double height, {
    double borderRadius = 8,
    bool isCircle = false,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(position * 2 - 1.3, 0),
          end: Alignment(position * 2 - 0.7, 0),
          colors: [Colors.grey[200]!, Colors.grey[100]!, Colors.grey[200]!],
        ).createShader(bounds);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) sl<GoRouter>().pop(startAnimation);
      },
      child: ChangeNotifierProvider(
        create: (_) => _isYoga
            ? CmsProvider.yoga(widget.yogaContentModel!)
            : CmsProvider(widget.collection ?? '', widget.id ?? ''),
        child: Scaffold(
          body: Consumer<CmsProvider>(
            builder: (context, p, _) {
              if (p.isLoading) {
                return _buildShimmer();
              }

              // Yoga content path
              if (_isYoga) {
                return _buildDisplay(
                  still: PlayVisualAsset.tryParseMap(
                    widget.yogaContentModel?.stillVisualMap,
                  ),
                  playing: PlayVisualAsset.tryParseMap(
                    widget.yogaContentModel?.playingVisualMap,
                  ),
                  audioPlaying: p.isPlaying,
                  titleSection: _buildTitleBlock(
                    title: widget.yogaContentModel!.title,
                    subtitle:
                        widget.yogaContentModel!.contentDescription?['en'] ??
                            '',
                  ),
                  activeContent: Consumer<CmsProvider>(
                    builder: (context, provider, _) {
                      return LyricLineBuilder(
                        yogaSegments: provider.yogaSegments,
                        currentPosition: provider.currentPosition,
                        totalDuration: provider.totalDuration,
                        activeColor: _lyricColor,
                        inactiveColor: _lyricColor,
                        timings: provider.audioTimings,
                      );
                    },
                  ),
                  progressSection: Consumer<CmsProvider>(
                    builder: (context, provider, _) {
                      return AudioProgressBar(
                        currentPosition: provider.currentPosition,
                        totalDuration: provider.totalDuration,
                        onSeek: provider.seek,
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
                      return ListenableBuilder(
                        listenable: sl<LibraryProvider>(),
                        builder: (context, _) {
                          return MediaControls(
                            isPlaying: provider.isPlaying,
                            sessionStarted: startAnimation,
                            audioReady: provider.audioReady,
                            playPulseAnimation: _playPulseAnimation,
                            repeatAsset: Assets.icons.repeatIcon,
                            back10Asset: Assets.icons.back10,
                            forward10Asset: Assets.icons.forward10,
                            heartAsset: Assets.icons.heartButton,
                            isFavorited:
                                sl<LibraryProvider>().isFavorited(_contentId),
                            onHeart: _handleToggleFavorite,
                            onPlayPause: () {
                              if (!startAnimation) _onFirstPlay();
                              provider.playPause();
                            },
                            onBack10: provider.seekBackward,
                            onForward10: provider.seekForward,
                          );
                        },
                      );
                    },
                  ),
                );
              }

              // CMS content path
              if (p.cms == null) {
                return const Center(child: Text('No data found'));
              }
              return _buildDisplay(
                still: PlayVisualAsset.stillFromCms(p.cms),
                playing: PlayVisualAsset.playingFromCms(p.cms),
                audioPlaying: p.isPlaying,
                titleSection: _buildTitleBlock(
                  title: p.cms?.title ?? '',
                  subtitle: _extractDescription(p.cms?.contentDescription),
                ),
                activeContent: Consumer<CmsProvider>(
                  builder: (context, provider, _) {
                    return LyricLineBuilder(
                      segments: p.segments,
                      currentPosition: provider.currentPosition,
                      totalDuration: provider.totalDuration,
                      activeColor: _lyricColor,
                      inactiveColor: _lyricColor,
                      timings: provider.audioTimings,
                    );
                  },
                ),
                progressSection: Consumer<CmsProvider>(
                  builder: (context, provider, _) {
                    return AudioProgressBar(
                      currentPosition: provider.currentPosition,
                      totalDuration: provider.totalDuration,
                      onSeek: provider.seek,
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
                    return ListenableBuilder(
                      listenable: sl<LibraryProvider>(),
                      builder: (context, _) {
                        return MediaControls(
                          isPlaying: provider.isPlaying,
                          sessionStarted: startAnimation,
                          audioReady: provider.audioReady,
                          playPulseAnimation: _playPulseAnimation,
                          repeatAsset: Assets.icons.repeatIcon,
                          back10Asset: Assets.icons.back10,
                          forward10Asset: Assets.icons.forward10,
                          heartAsset: Assets.icons.heartButton,
                          isFavorited:
                              sl<LibraryProvider>().isFavorited(_contentId),
                          onHeart: _handleToggleFavorite,
                          onPlayPause: () {
                            if (!startAnimation) _onFirstPlay();
                            provider.playPause();
                          },
                          onBack10: provider.seekBackward,
                          onForward10: provider.seekForward,
                        );
                      },
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

  // ── Shared widgets ──

  Widget _buildTitleBlock({required String title, required String subtitle}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: _titleColor,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          Space.h4,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: _subtitleColor,
            ),
          ),
        ],
      ],
    );
  }

  // ── Unified layout ──

  Widget _buildDisplay({
    required PlayVisualAsset? still,
    required PlayVisualAsset? playing,
    required bool audioPlaying,
    required Widget titleSection,
    required Widget activeContent,
    required Widget progressSection,
    required Widget controlSection,
  }) {
    _analyzeBackgroundColor(still);

    final size = MediaQuery.sizeOf(context);
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. Full-screen motion / still background
          if (_showBackground)
            Positioned.fill(
              child: PlayVisualStack(
                still: still,
                playing: playing,
                sessionStarted: startAnimation,
                audioPlaying: audioPlaying,
              ),
            ),

          // 2. Gradient overlays for readability
          _buildGradientOverlay(),

          // 3. Top bar
          ListenableBuilder(
            listenable: sl<LibraryProvider>(),
            builder: (context, _) {
              return PlayVisualsTopBar(
                safeTop: safeTop,
                onBack: () => sl<GoRouter>().pop(startAnimation),
                favouriteAsset: Assets.icons.heartButton,
                isFavorited: sl<LibraryProvider>().isFavorited(_contentId),
                onFavourite: _handleToggleFavorite,
              );
            },
          ),

          // 4. Top-left lyrics — fades in after play starts
          Positioned(
            top: safeTop + 64,
            left: 20,
            right: 20,
            child: IgnorePointer(
              ignoring: !startAnimation,
              child: AnimatedOpacity(
                opacity: startAnimation ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: activeContent,
                ),
              ),
            ),
          ),

          // 5. Bottom controls — title (pre-play) + progress bar + media buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: safeBottom + 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title — shown just above play button before session starts
                AnimatedOpacity(
                  opacity: startAnimation ? 0 : 1,
                  duration: const Duration(milliseconds: 400),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: startAnimation
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                              left: 32,
                              right: 32,
                            ),
                            child: titleSection,
                          ),
                  ),
                ),
                // Progress bar — appears after play starts
                AnimatedOpacity(
                  opacity: startAnimation ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: startAnimation
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: progressSection,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                Space.h4,
                controlSection,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    final colors = _isDarkBackground
        ? [
            Colors.black.withValues(alpha: 0.40),
            Colors.black.withValues(alpha: 0.12),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.15),
            Colors.black.withValues(alpha: 0.45),
          ]
        : [
            Colors.white.withValues(alpha: 0.45),
            Colors.white.withValues(alpha: 0.15),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.10),
            Colors.black.withValues(alpha: 0.30),
          ];

    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.25, 0.55, 0.80, 1.0],
            colors: colors,
          ),
        ),
      ),
    );
  }
}

