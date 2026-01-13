import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'dart:async';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';
import 'package:mindfulminis/features/play%20visuals/models/audolyric.dart';
import 'package:mindfulminis/features/play%20visuals/provider/cms_provider.dart';
import 'package:mindfulminis/features/play%20visuals/widgets/yoga_progress_bar.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/providers/yoga_play_visuals_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

class PlayVisualsCopy extends StatefulWidget {
  static String routeName = 'play-visuals-copy';
  static String routePath = '/play-visuals-copy';
  final String? collection;
  final String? id;
  final YogaContentModel? yogaContentModel;

  const PlayVisualsCopy({
    super.key,
    this.collection,
    this.id,
    this.yogaContentModel,
  });

  @override
  State<PlayVisualsCopy> createState() => _PlayVisualsCopyState();
}

class _PlayVisualsCopyState extends State<PlayVisualsCopy>
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

    // Initialize progress timer (though it's managed by AudioProgressWithLyrics in yoga display)
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
      _lottiController.forward(from: 0.0);
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

  void _pauseAnimation() {
    setState(() {
      isPlaying = false;
    });
    _segmentController.stop();
    if (_progressTimer?.isActive ?? false) {
      _progressTimer?.cancel();
    }
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
          // Lottie animation background
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
                  //   fit: BoxFit.fill,
                ),
                //  Lottie.asset(
                //   backgroundLoading: true,
                //   fit: BoxFit.fill,
                //   Assets.vectors.flow146,
                //   controller: _lottiController,
                //   onLoaded: (composition) {
                //     _lottiController.duration = composition.duration;
                //   },
                // ),
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

                // Progress bar
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

  /// Build CMS display with regular content
  Widget _buildCmsDisplay(BuildContext context, double height, CmsProvider p) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          //lottie
          if (_showLottie)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: MediaQuery.sizeOf(context).height * 0.1,
              child: Hero(
                tag: 'audio',
                child: Lottie.asset(
                  backgroundLoading: true,
                  fit: BoxFit.fill,
                  Assets.vectors.flow146,
                  controller: _lottiController,
                  onLoaded: (composition) {
                    _lottiController.duration = composition.duration;
                  },
                ),
              ),
            ),

          // top app bar
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

          // lyrics text - not used for yoga
          // Positioned(
          //   top: 110,
          //   left: 0,
          //   right: 100,
          //   child: AnimatedOpacity(
          //     opacity: !startAnimation ? 0 : 1,
          //     duration: Duration(milliseconds: 1000),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       child: LyricLineBuilder(segments: p.segments),
          //     ),
          //   ),
          // ),

          //content
          Positioned(
            left: 0,
            right: 0,
            bottom: height * 0.15,
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
                        'Tenali Raman and the Wise Judgment',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "The Mango Tree teaches that true prosperity comes from unity and sharing, showing how cooperation fosters abundance and harmony for all.",
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Play button at bottom
          Positioned(
            bottom: height * 0.05,
            left: 0,
            right: 0,
            child: Center(child: _playButton()),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(String assetPath) {
    return IconButton(
      onPressed: () {},
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
        } else if (isPlaying) {
          _pauseAnimation();
        } else {
          setState(() {
            isPlaying = true;
          });
          _playNextSegment();
          _startProgressTimer();
        }
      },
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: Theme.of(context).primaryColor,
        size: 28,
      ),
    );
  }

  final List<AudioChapter> chapters = [
    AudioChapter(
      title: 'Intro',
      start: Duration(seconds: 0),
      end: Duration(seconds: 2),
    ),
    AudioChapter(
      title: 'Verse 1',
      start: Duration(seconds: 3),
      end: Duration(seconds: 5),
    ),
    AudioChapter(
      title: 'Chorus',
      start: Duration(seconds: 5),
      end: Duration(seconds: 8),
    ),
    AudioChapter(
      title: 'Verse 2',
      start: Duration(seconds: 8),
      end: Duration(seconds: 10),
    ),
  ];

  final List<LyricLine> lyrics = [
    LyricLine(timestamp: Duration(seconds: 0), text: ""),
    LyricLine(
      timestamp: Duration(seconds: 2),
      text: "Wake up to a brand new day",
    ),
    LyricLine(
      timestamp: Duration(seconds: 3),
      text: "The sun is shining bright",
    ),
    LyricLine(timestamp: Duration(seconds: 5), text: "It's time to be alive"),
    LyricLine(
      timestamp: Duration(seconds: 8),
      text: "And feel the magic in the air",
    ),
  ];
}
