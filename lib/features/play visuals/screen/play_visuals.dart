import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/common/screens/upcoming_activity.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/play%20visuals/models/audolyric.dart';
import 'package:mindfulminis/features/play%20visuals/screen/chapter_wise_progress.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class PlayVisuals extends StatefulWidget {
  static String routeName = 'play-visuals';
  static String routePath = '/play-visuals';

  const PlayVisuals({super.key});

  @override
  State<PlayVisuals> createState() => _PlayVisualsState();
}

class _PlayVisualsState extends State<PlayVisuals>
    with TickerProviderStateMixin {
  bool startAnimation = false;
  late AnimationController _controller;
  late AnimationController _lottiController;

  late Animation<Offset> _textOffsetAnimation;
  // late Animation<double> _scaleAnimation;
  // late Animation<double> _scaleVectorsAnimation;

  // late final Animation<Offset> _purpleSlideAnimation;
  // late final Animation<Offset> _redSlideAnimation;
  // late final Animation<Offset> _yellowSlideAnimation;
  // late final Animation<Offset> _greenSlideAnimation;

  //

  bool _showLottie = false;
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

    _textOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 10), // move text downward off-screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Animate left buttons
    // Animate like spaceEvenly (further out = larger offset)
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
    super.dispose();
  }

  void start() {
    setState(() {
      startAnimation = true;
    });
    _controller.forward();
    _lottiController.forward(from: 0.0);
  }

  void _playAnimation() {
    _controller.forward(from: 0.0); // Play from start
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SizedBox(
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
                    // width: double.infinity,
                    backgroundLoading: true,
                    fit: BoxFit.fill,
                    Assets.vectors.flow146, // Your Lottie path
                    controller: _lottiController,
                    onLoaded: (composition) {
                      _lottiController.duration = composition.duration;
                    },
                  ),
                ),
              ),

            // top app bar icon
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
                      onPressed: () {
                        sl<GoRouter>().pop();
                      },
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
            //lyricess text
            Positioned(
              top: 110,
              left: 0,
              right: 100,
              child: AnimatedOpacity(
                opacity: !startAnimation ? 0 : 1,
                duration: Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LyricLineBuilder(
                    lyrics: lyrics,
                    totalDuration: Duration(seconds: 90),
                  ),
                ),
              ),
            ),

            //content
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
                        Space.h12,
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedOpacity(
                    opacity: !startAnimation ? 0 : 1,
                    duration: Duration(milliseconds: 600),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AudioProgressWithLyrics(
                        totalDuration: Duration(seconds: 10),
                        chapterTimestamps: chapters,
                        lyrics: lyrics,
                        onComplete: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            // showDragHandle: true,
                            enableDrag: true,
                            context: context,
                            builder: (context) {
                              return UpcomingActivity();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if (startAnimation) Space.h12,
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
                              child: _iconButton(Assets.icons.back10),
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
                              child: _iconButton(Assets.icons.forward10),
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
        backgroundColor: HexColor('#F2F1FA'),
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
      onPressed: start,
      icon: SvgPicture.asset(
        Assets.icons.playButton,
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
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
      timestamp: Duration(seconds: 8),
      text: "Let the sunlight warm your face",
    ),
    LyricLine(
      timestamp: Duration(seconds: 12),
      text: "Stretch your arms, breathe in deep",
    ),
    LyricLine(
      timestamp: Duration(seconds: 20),
      text: "This is the chorus we repeat",
    ),
    LyricLine(
      timestamp: Duration(seconds: 25),
      text: "Find your peace, feel the beat",
    ),
    LyricLine(
      timestamp: Duration(seconds: 29),
      text: "Another verse, we go again",
    ),
    LyricLine(
      timestamp: Duration(seconds: 33),
      text: "Let the rhythm take you in",
    ),
    LyricLine(
      timestamp: Duration(seconds: 40),
      text: "Wind it down, the end is near",
    ),
    LyricLine(
      timestamp: Duration(seconds: 45),
      text: "Thank you for being here",
    ),
    LyricLine(
      timestamp: Duration(seconds: 50),
      text: "Thank you for being here",
    ),
    LyricLine(timestamp: Duration(seconds: 54), text: "..."),
  ];
}

class GradientProgressBar extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final double height;
  final BorderRadiusGeometry borderRadius;

  const GradientProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          // Background track
          Container(height: height, color: Colors.grey.shade300),
          // Gradient progress fill
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6E40F9),
                    Color(0xFFA569FB),
                    Color(0xFFCE89FF),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
