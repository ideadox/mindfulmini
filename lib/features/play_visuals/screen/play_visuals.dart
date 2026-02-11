import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';
import 'package:mindfulminis/features/play_visuals/provider/cms_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/chapter_wise_progress.dart';
import 'package:mindfulminis/features/play_visuals/widgets/yoga_progress_bar.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/providers/yoga_play_visuals_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
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
  bool isPlaying = false;
  late AnimationController _controller;
  late AnimationController _lottiController;
  late Animation<Offset> _textOffsetAnimation;

  // For yoga segment animation
  late AnimationController _segmentController;
  late Animation<double> _segmentFadeAnimation;
  int _currentSegmentIndex = 0;
  bool _yogaAnimationRunning = false;
  List<YogaSegment> _currentSegments = [];
  Timer? _progressTimer;
  Duration _elapsedTime = Duration.zero;

  bool _showLottie = false;

  // Slide animation variables for multi-button layout
  late final Animation<Offset> _leftMostSlide;
  late final Animation<Offset> _leftSlide;
  late final Animation<Offset> _rightSlide;
  late final Animation<Offset> _rightMostSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _lottiController = AnimationController(vsync: this);

    _segmentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _segmentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _segmentController, curve: Curves.easeInOut),
    );

    _textOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 10), // move text downward off-screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Initialize slide animations for buttons
    _leftMostSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-2.8, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _leftSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.4, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rightSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.4, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rightMostSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.8, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Initialize progress timer
    _progressTimer = Timer(Duration.zero, () {});

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _showLottie = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _lottiController.dispose();
    _segmentController.dispose();
    if (_progressTimer?.isActive ?? false) {
      _progressTimer?.cancel();
    }
    super.dispose();
  }

  void _playYogaSegmentAnimation(List<YogaSegment> segments) {
    if (_yogaAnimationRunning || segments.isEmpty) return;

    _yogaAnimationRunning = true;
    _currentSegments = segments;
    _currentSegmentIndex = 0;
    _playNextSegment();
  }

  void _playNextSegment() {
    if (_currentSegmentIndex >= _currentSegments.length) {
      _yogaAnimationRunning = false;
      return;
    }

    setState(() {
      _currentSegmentIndex;
    });

    final currentSegment = _currentSegments[_currentSegmentIndex];

    // Fade in: 600ms
    _segmentController.forward(from: 0.0).then((_) {
      // Stay visible for the segment duration, then fade out
      Future.delayed(currentSegment.duration, () {
        // Check if still playing
        if (!isPlaying) return;

        // Fade out: 300ms
        _segmentController.reverse().then((_) {
          if (_currentSegmentIndex + 1 < _currentSegments.length && isPlaying) {
            setState(() {
              _currentSegmentIndex++;
            });
            // Move to next segment
            Future.delayed(Duration(milliseconds: 200), () {
              _playNextSegment();
            });
          } else {
            _yogaAnimationRunning = false;
          }
        });
      });
    });
  }

  void start() {
    setState(() {
      startAnimation = true;
      isPlaying = !isPlaying;
      _elapsedTime = Duration.zero;
    });
    if (isPlaying) {
      _controller.forward();
      // Only forward Lottie controller for yoga content (which still uses Lottie)
      if (widget.yogaContentModel != null && _lottiController.duration != null) {
        _lottiController.forward(from: 0.0);
      }
      _startProgressTimer();
    } else {
      _segmentController.stop();
      if (_progressTimer?.isActive ?? false) {
        _progressTimer?.cancel();
      }
    }
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (_) {
      setState(() {
        _elapsedTime += Duration(milliseconds: 100);
      });
    });
  }

  String _extractDescription(dynamic contentDescription) {
    try {
      if (contentDescription == null) return '';
      if (contentDescription is Map<String, dynamic>) {
        // If it has a 'root' structure (ContentDescription object)
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
                description += text + ' ';
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
    double height = MediaQuery.sizeOf(context).height;

    // If yogaContentModel is provided, use YogaPlayVisualsProvider
    if (widget.yogaContentModel != null) {
      return ChangeNotifierProvider(
        create:
            (context) =>
                YogaPlayVisualsProvider(yogaContent: widget.yogaContentModel!),
        child: Scaffold(
          body: Consumer<YogaPlayVisualsProvider>(
            builder: (context, yogaProvider, _) {
              if (!yogaProvider.isInitialized) {
                return Center(child: CircularProgressIndicator());
              }

              return _buildYogaDisplay(context, height, yogaProvider);
            },
          ),
        ),
      );
    }

    // Otherwise use CmsProvider for regular content
    return ChangeNotifierProvider(
      create:
          (context) => CmsProvider(widget.collection ?? '', widget.id ?? ''),
      child: Scaffold(
        body: Consumer<CmsProvider>(
          builder: (context, p, _) {
            if (p.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (p.cms == null) {
              return Center(child: Text('No data found'));
            }
            return _buildCmsDisplay(context, height, p);
          },
        ),
      ),
    );
  }

  /// Build yoga display with line-by-line content
  Widget _buildYogaDisplay(
    BuildContext context,
    double height,
    YogaPlayVisualsProvider yogaProvider,
  ) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background image/animation
          if (_showLottie)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: height * 0.1,
              child: Hero(
                tag: 'audio',
                child: CachedNetworkImage(
                  imageUrl:
                      ApiConstants.mediaBaseUrl +
                      (widget.yogaContentModel?.media?['filename'] ?? ''),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

          // Top app bar with navigation
          Positioned(
            top: 50,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => sl<GoRouter>().pop(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(Assets.icons.heartButton),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: height * 0.15,
            child: Column(
              children: [
                // Title and description - hide when playing
                SlideTransition(
                  position: _textOffsetAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!startAnimation)
                        Text(
                          widget.yogaContentModel!.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (!startAnimation)
                        Text(
                          textAlign: TextAlign.center,
                          widget.yogaContentModel!.contentDescription?['en'] ??
                              '',
                          style: const TextStyle(color: Colors.black45),
                        ),
                      if (!startAnimation) Space.h12,
                    ],
                  ),
                ),
                // Yoga segment content
                AnimatedOpacity(
                  opacity: startAnimation ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: Consumer<YogaPlayVisualsProvider>(
                    builder: (context, provider, _) {
                      // Trigger animation when segments are loaded
                      if (provider.segments.isNotEmpty &&
                          !_yogaAnimationRunning &&
                          startAnimation) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _playYogaSegmentAnimation(provider.segments);
                        });
                      }

                      // Show completion or current segment
                      if (_currentSegmentIndex >= provider.segments.length) {
                        return const Text(
                          'Complete',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        );
                      }

                      final currentSegment =
                          provider.segments[_currentSegmentIndex];

                      return FadeTransition(
                        opacity: _segmentFadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children:
                                  currentSegment.textSpans.map((span) {
                                    return TextSpan(
                                      text: span.text,
                                      style: span.textStyle,
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Yoga content positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: height * 0.06,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: startAnimation ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer<YogaPlayVisualsProvider>(
                      builder: (context, provider, _) {
                        return YogaProgressBar(
                          totalDuration: provider.totalDuration,
                          currentPosition: _elapsedTime,
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey.shade300,
                          thumbColor: Theme.of(context).primaryColor,
                        );
                      },
                    ),
                  ),
                ),
                if (startAnimation) Space.h12,
                // Multi-button control panel
                SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Repeat button (left-most)
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _leftMostSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: _iconButton(Assets.icons.repeatIcon),
                          ),
                        ),
                      ),
                      // Back 10 seconds button
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _leftSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: _iconButton(Assets.icons.back10),
                          ),
                        ),
                      ),
                      // Play/Pause button (center)
                      _playButton(),
                      // Forward 10 seconds button
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _rightSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: _iconButton(Assets.icons.forward10),
                          ),
                        ),
                      ),
                      // Heart/Favorite button (right-most)
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _rightMostSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: _iconButton(Assets.icons.heartButton),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build CMS display with regular content (stories/meditations)
  Widget _buildCmsDisplay(BuildContext context, double height, CmsProvider p) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background image - dynamic from CMS
          if (_showLottie && p.cms?.media?.filename != null)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: MediaQuery.sizeOf(context).height * 0.1,
              child: Hero(
                tag: 'audio',
                child: CachedNetworkImage(
                  imageUrl: '${ApiConstants.mediaBaseUrl}${p.cms!.media!.filename}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

          // Top app bar
          Positioned(
            top: 50,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => sl<GoRouter>().pop(),
                    icon: Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(Assets.icons.heartButton),
                  ),
                ),
              ],
            ),
          ),

          // Animated lyrics text - synced with audio!
          Positioned(
            top: 110,
            left: 0,
            right: 100,
            child: AnimatedOpacity(
              opacity: !startAnimation ? 0 : 1,
              duration: Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LyricLineBuilder(segments: p.segments),
              ),
            ),
          ),

          // Content - title and description at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: height * 0.06,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _textOffsetAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        p.cms?.title ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        _extractDescription(p.cms?.contentDescription),
                        style: const TextStyle(color: Colors.black45),
                      ),
                      Space.h12,
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Audio progress slider
                Consumer<CmsProvider>(
                  builder: (context, provider, _) {
                    return AnimatedOpacity(
                      opacity: !startAnimation ? 0 : 1,
                      duration: Duration(milliseconds: 600),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if (provider.totalDuration.inSeconds > 0)
                              Slider(
                                value: provider.currentPosition.inSeconds.toDouble(),
                                max: provider.totalDuration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  provider.seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            if (provider.totalDuration.inSeconds > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(provider.currentPosition),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    _formatDuration(provider.totalDuration),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (startAnimation) Space.h12,
                
                // Multi-button control panel
                SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _leftMostSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: _iconButton(Assets.icons.repeatIcon),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _leftSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Consumer<CmsProvider>(
                              builder: (context, provider, _) {
                                return _iconButton(
                                  Assets.icons.back10,
                                  onPressed: () => provider.seekBackward(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Play button - always active
                      _playButton(),
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _rightSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Consumer<CmsProvider>(
                              builder: (context, provider, _) {
                                return _iconButton(
                                  Assets.icons.forward10,
                                  onPressed: () => provider.seekForward(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: !startAnimation,
                        child: SlideTransition(
                          position: _rightMostSlide,
                          child: AnimatedOpacity(
                            opacity: startAnimation ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: _iconButton(
                              Assets.icons.heartButton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(String assetPath, {VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed ?? () {},
      style: IconButton.styleFrom(
        maximumSize: const Size(40, 40),
        minimumSize: const Size(40, 40),
        alignment: Alignment.center,
        backgroundColor: const Color(0xFFF2F1FA),
      ),
      icon: SvgPicture.asset(assetPath),
    );
  }

  Widget _playButton() {
    return Consumer<CmsProvider>(
      builder: (context, provider, _) {
        return IconButton(
          style: IconButton.styleFrom(
            maximumSize: const Size(50, 50),
            minimumSize: const Size(50, 50),
            alignment: Alignment.center,
            backgroundColor: Colors.grey.shade300,
          ),
          onPressed: () {
            if (!startAnimation) {
              start();
            }
            provider.playPause();
          },
          icon: Icon(
            provider.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
        );
      },
    );
  }
}
