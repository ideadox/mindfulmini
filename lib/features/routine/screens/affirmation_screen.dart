import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/common/widgets/listening_widget.dart';
import 'package:mindfulminis/features/routine/models/affir_text_detail.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:video_player/video_player.dart';
import '../widgets/complete_affirmation_widget.dart';

class AffirmationScreen extends StatefulWidget {
  static String routeName = 'affirmation-screen';
  static String routePath = '/affirmation-screen';
  const AffirmationScreen({super.key});

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen>
    with TickerProviderStateMixin {
  int totalSteps = 3;

  bool _hasStartedBirds = false;
  bool _hasStartedBird = false;
  bool _butterFlyHasStarted = false;
  late AnimationController _controller;
  late final AnimationController _birdsLottieController;
  late final AnimationController _birdLottieController;
  late VideoPlayerController _videoPlayerController;
  late Animation<double> gradientProgress;

  late Animation<double> topCloudAnim;
  late Animation<double> bottomGreenAnim;
  late Animation<double> blueOvalAnim;

  late Animation<double> redBackAnim;
  late Animation<double> leftLeafAnim;
  late Animation<double> rightLeafAnim;
  late Animation<double> rainbowAnim;
  late Animation<double> centerBoyAnim;
  late Animation<double> rainbowLiftAnim;
  late Animation<double> textAnim;
  late Animation<double> text2Anim;
  late Animation<double> rainbowExitAnim;
  late Animation<double> topCloudExitAnim;
  late Animation<double> rightLeafExitAnim;
  late Animation<double> centerBoyExitAnim;
  late Animation<double> textExitAnim;
  late Animation<double> text2ExitAnim;
  late Animation<double> redBackExitAnim;
  late Animation<double> circularRaninBowAnim;
  late Animation<double> circularRaninExitBowAnim;

  late Animation<double> topStepperAnim;
  late Animation<double> bottomWhiteShateAnim;
  late Animation<double> girlPlaceHandAnim;

  late Animation<double> bottomWhiteShateExitAnim;
  late Animation<double> girlPlaceHandExitAnim;

  late Animation<double> bottomPurpleRedAnim;
  late Animation<double> bottomPurpleRedExitAnim;
  late Animation<double> placeHandTextAnim;
  late Animation<double> placeHandTextExitAnim;
  late Animation<double> readThisAloudTextAnim;
  late Animation<double> readThisAloudTextExitAnim;
  late Animation<double> textLine1Anim;
  late Animation<double> textLine2Anim;
  late Animation<double> textLine3Anim;
  late Animation<double> textLine1ExitAnim;
  late Animation<double> textLine2ExitAnim;
  late Animation<double> textLine3ExitAnim;
  late Animation<double> sunAnim;
  late Animation<double> bottomGreenExitAnim;
  late Animation<double> bottomGreenLayerAnim;

  late Animation<double> blueOvalExitAnim;
  late Animation<double> seedWithBirdAnim;
  late Animation<double> seedAnim;
  late Animation<double> seedDropAnim;
  late Animation<double> sunExitAnim;
  late Animation<double> bottomPurpleRedReturnAnim;
  late Animation<double> letDoItAgaintextAnim;

  late Animation<double> plantPhase1Anim;

  late Animation<double> plantPhase2Anim;

  late Animation<double> plantPhaseExitAnim;

  late Animation<double> bottomFlowersAnim;
  late Animation<double> didItTextAnim;

  late Animation<double> sun2Anim;
  late Animation<double> sun2ExitAnim;

  double firstStart = 0.0,
      firstEnd = 0.5,
      secondStart = 0.08,
      secondEnd = 0.1,
      thirdStart = 0.12,
      thirdEnd = 0.125,
      fourthStart = 0.15,
      fourthEnd = 0.18,
      fifthStart = 0.2,
      fifthEnd = 0.25;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 44, milliseconds: 200),
    );

    _birdsLottieController = AnimationController(vsync: this);
    _birdLottieController = AnimationController(vsync: this);
    _videoPlayerController = VideoPlayerController.asset(
      Assets.vectors.a202502121524117946638,
    )..initialize();
    _controller.addListener(() {
      if (_controller.value >= 0.54 && !_hasStartedBirds) {
        _hasStartedBirds = true;
        _birdsLottieController.forward();
      }

      if (_controller.value >= 0.58 &&
          _controller.value < 0.7 &&
          !_hasStartedBird) {
        _hasStartedBird = true;
        _birdLottieController.forward();
      }

      if (_controller.value >= 0.95 && !_butterFlyHasStarted) {
        _butterFlyHasStarted = true;
        _videoPlayerController.play();
      }

      if (_controller.isCompleted) {
        SmartDialog.show(
          clickMaskDismiss: false,
          backType: SmartBackType.block,
          maskWidget: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black12),
          ),
          builder: (context) {
            return CompleteAffirmationDialog();
          },
        );
      }
    });

    _gradientAnim();

    _listenAndSuccess();
    _plantGrowAnim();

    //first frame
    bottomGreenAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.fastEaseInToSlowEaseOut),
    );

    blueOvalAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.fastEaseInToSlowEaseOut),
    );
    topCloudAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.easeIn),
    );
    redBackAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.easeOutBack),
    );
    leftLeafAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.easeOutBack),
    );
    rightLeafAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.easeOutBack),
    );
    rainbowAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.easeOutBack),
    );
    centerBoyAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.05, curve: Curves.easeOutBack),
    );

    //second frame
    rainbowLiftAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.1, curve: Curves.easeOut),
    );
    textAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.1, curve: Curves.fastOutSlowIn),
    );

    rightLeafExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.1, curve: Curves.easeIn),
    );

    //third frame
    textExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.12, 0.125, curve: Curves.fastOutSlowIn),
    );
    rainbowExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.12, 0.125, curve: Curves.easeOutSine),
    );

    topCloudExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.12, 0.125, curve: Curves.easeIn),
    );
    text2Anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.12, 0.13, curve: Curves.fastOutSlowIn),
    );
    text2ExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.15, 0.18, curve: Curves.fastOutSlowIn),
    );

    //fourth frame
    centerBoyExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.15, 0.18, curve: Curves.easeIn),
    );
    redBackExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.15, 0.18, curve: Curves.easeIn),
    );

    // fifth frame
    circularRaninBowAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.15, 0.18, curve: Curves.easeIn),
    );

    circularRaninExitBowAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.25, curve: Curves.easeIn),
    );

    //sixthframe
    topStepperAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.25, curve: Curves.fastOutSlowIn),
    );
    bottomWhiteShateAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.24, 0.25, curve: Curves.fastOutSlowIn),
    );

    textLine1Anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.25, curve: Curves.easeOut),
    );
    textLine1ExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 0.35, curve: Curves.easeOut),
    );

    girlPlaceHandAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.25, curve: Curves.easeIn),
    );

    bottomWhiteShateExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 0.35, curve: Curves.fastOutSlowIn),
    );

    girlPlaceHandExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 0.35, curve: Curves.easeIn),
    );

    // seventh frame

    bottomPurpleRedAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 0.35, curve: Curves.fastOutSlowIn),
    );

    bottomPurpleRedExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 0.51, curve: Curves.fastOutSlowIn),
    );

    // bird frames
    sunAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.51, 0.53, curve: Curves.fastOutSlowIn),
    );

    bottomGreenLayerAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.51, 0.53, curve: Curves.fastOutSlowIn),
    );

    blueOvalExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.51, 0.52, curve: Curves.easeIn),
    );
    bottomGreenExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.51, 0.52, curve: Curves.easeIn),
    );

    seedAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.58, 0.68, curve: Curves.easeInOut),
    );

    sunExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.69, 0.70, curve: Curves.easeIn),
    );

    bottomPurpleRedReturnAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.69, 0.70, curve: Curves.easeInOut),
    );

    _runAnimation();
  }

  _gradientAnim() {
    gradientProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  _plantGrowAnim() {
    sun2Anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.84, 0.85, curve: Curves.fastOutSlowIn),
    );

    // Phase 1: plant grows up

    plantPhase1Anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.84, 0.85, curve: Curves.easeOut),
    );

    // Switch phase images
    plantPhase2Anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.87, 0.9, curve: Curves.linear),
    );

    bottomFlowersAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.95, 0.97, curve: Curves.easeIn),
    );

    // Exit phase: plant shrinks back down
    plantPhaseExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.85, 0.87, curve: Curves.easeOut),
    );

    didItTextAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.95, 0.96, curve: Curves.easeOut),
    );
    sun2ExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.95, 0.97, curve: Curves.fastOutSlowIn),
    );
  }

  late Animation<double> listenAppearAnim;
  late Animation<double> listenAppearExitAnim;
  late Animation<double> listen1AppearAnim;
  late Animation<double> listen1AppearExitAnim;
  late Animation<double> listen2AppearAnim;
  late Animation<double> listen2AppearExitAnim;

  late Animation<double> listenSuccessFadeIn;
  late Animation<double> listenSuccessMoveUp;
  late Animation<double> listenSuccess1FadeIn;
  late Animation<double> listenSuccess1MoveUp;
  late Animation<double> listenSuccess2FadeIn;
  late Animation<double> listenSuccess2MoveUp;

  _listenAndSuccess() {
    listenAppearAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.43, 0.45, curve: Curves.easeOut),
    );

    listenAppearExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.48, 0.49, curve: Curves.easeOut),
    );

    listenSuccessFadeIn = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.48, 0.49, curve: Curves.easeIn),
    );

    listenSuccessMoveUp = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 0.51, curve: Curves.easeOut),
    );

    //appear 1
    listen1AppearAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.77, 0.78, curve: Curves.easeOut),
    );

    listen1AppearExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.82, 0.83, curve: Curves.easeOut),
    );

    listenSuccess1FadeIn = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.82, 0.83, curve: Curves.easeIn),
    );

    listenSuccess1MoveUp = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.84, 0.85, curve: Curves.easeOut),
    );

    //appear 2
    listen2AppearAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.77, 0.78, curve: Curves.easeOut),
    );

    listen2AppearExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.82, 0.83, curve: Curves.easeOut),
    );

    listenSuccess2FadeIn = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.82, 0.83, curve: Curves.easeIn),
    );

    listenSuccess2MoveUp = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.84, 0.85, curve: Curves.easeOut),
    );
  }

  _runAnimation() {
    _controller.forward(from: 0.5);
  }

  final List<AffirTextDetail> textLines = [
    AffirTextDetail(start: 0.08, end: 0.12, text: 'Hi Tom!'),
    AffirTextDetail(start: 0.12, end: 0.15, text: 'Let’s do a affirmation'),
    AffirTextDetail(
      start: 0.2,
      end: 0.3,
      text: 'Placing a hand on the heart ❤️✋',
    ),

    AffirTextDetail(start: 0.3, end: 0.4, text: 'Now, read this aloud'),
    AffirTextDetail(
      start: 0.4,
      end: 0.48,
      text: '"I am brave, and I learn new things every day."',
    ),

    AffirTextDetail(
      start: 0.71,
      end: 0.75,
      text: 'Bravo!\n Let’s do it again!',
    ),
    AffirTextDetail(
      start: 0.75,
      end: 0.82,
      text: '"I am brave, and I learn new things every day."',
    ),
    AffirTextDetail(
      start: 0.86,
      end: 0.88,
      text: ' Awesome!\nLet’s do one more!',
    ),

    AffirTextDetail(
      start: 0.88,
      end: 0.93,
      text: '"I am brave, and I learn new things every day."',
    ),
    AffirTextDetail(start: 0.96, end: 1.0, text: 'Woohoo!\nYou did it! 🎊'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _birdsLottieController.dispose();
    _birdLottieController.dispose();
    _controller.removeListener(() {});
    _birdsLottieController.removeListener(() {});
    _birdLottieController.removeListener(() {});
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          Gradient? gradient;

          if (gradientProgress.value < 0.51) {
            gradient = LinearGradient(
              colors: [
                HexColor('#9D9FE6').withValues(alpha: 0.2),
                HexColor('#FFFFFF').withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );
          } else if (gradientProgress.value >= 0.69) {
            gradient = LinearGradient(
              colors: [
                HexColor('#CFFFCD').withValues(alpha: 0.4),
                HexColor('#CFFFCD').withValues(alpha: 0.25),
                HexColor('#E2C7FF').withValues(alpha: 0.2),
                HexColor('#FFFFFF').withValues(alpha: 0.2),
                HexColor('#F9F4D6').withValues(alpha: 0.2),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            );
          }
          return Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(gradient: gradient),
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: SvgPicture.asset(Assets.vectors.affirStarBack)),

            // butter fly video
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final value = _controller.value;

                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child:
                      value >= 0.95 && value <= 1.0
                          ? child
                          : const SizedBox.shrink(),
                );
              },
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),

            // first frame Top Cloud
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryOffset =
                    (1 - topCloudAnim.value) * size.height * 0.15;
                final exitOffset = topCloudExitAnim.value * size.height * 0.2;

                final totalOffset = entryOffset + exitOffset;

                return Positioned(top: -totalOffset, right: 0, child: child!);
              },
              child: Image.asset(Assets.vectors.affirTopRightCloud.path),
            ),

            //girl
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryValue = girlPlaceHandAnim.value;
                final exitValue = girlPlaceHandExitAnim.value;

                final double entryStart = -size.height;
                final double entryEnd = 200.0;
                double position =
                    entryStart + (entryEnd - entryStart) * entryValue;

                position += exitValue * entryStart;

                final opacity = (entryValue * (1 - exitValue)).clamp(0.0, 1.0);

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: position,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: SizedBox(
                height: 278,
                child: Image.asset(
                  Assets.vectors.affirPlaceHandGirl.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            //white shade on girl
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryValue = girlPlaceHandAnim.value;
                final exitValue = girlPlaceHandExitAnim.value;

                final double entryStart = -size.height;
                final double entryEnd = 200.0;
                double position =
                    entryStart + (entryEnd - entryStart) * entryValue;

                position += exitValue * entryStart;

                final opacity = (entryValue * (1 - exitValue)).clamp(0.0, 1.0);

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: position,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.white54,
              ),
            ),

            //fith frame  circular rainbow
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = 25.0 * circularRaninBowAnim.value;

                final opacity = 1.0 - circularRaninExitBowAnim.value;

                return Positioned.fill(
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 0.4),
                      child: child!,
                    ),
                  ),
                );
              },
              child: Image.asset(Assets.vectors.circularRainbow.path),
            ),

            // seventh frame Bottom Purple Red
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entry = bottomPurpleRedAnim.value; // Entry from top
                final exit = bottomPurpleRedExitAnim.value; // Exit (down)
                final returnVal =
                    bottomPurpleRedReturnAnim.value; // Return (up)

                final double entryStart = -size.height;
                final double entryEnd = 0.0;

                // Calculate base position
                double position = entryStart + (entryEnd - entryStart) * entry;

                // Apply exit movement
                position += exit * size.height;

                // Apply return movement back to visible
                // position -= returnVal * size.height;

                // Combine opacity only for entry and return, ignore exit fade
                final double opacity = (entry * (1.0 - exit)).clamp(0.0, 1.0);

                return Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: position,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(
                Assets.vectors.affirPurpleRedBackg.path,
                fit: BoxFit.contain,
              ),
            ),

            // bottom Purple Red with return
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final returnVal = bottomPurpleRedReturnAnim.value;

                final double entryStart = 0.0;
                final double entryEnd = 0.0;

                double position =
                    entryStart + (entryEnd - entryStart) * returnVal;

                final double opacity = (returnVal).clamp(0.0, 1.0);

                return Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: position,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(
                Assets.vectors.affirPurpleRedBackg.path,
                fit: BoxFit.contain,
              ),
            ),

            //stepper
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                int currentStep = 0;
                final opacity = topStepperAnim.value.clamp(0.0, 1.0);

                if (_controller.value >= 0.2) {
                  currentStep = 0;
                }
                if (_controller.value >= 0.75) {
                  currentStep = 1;
                }
                if (_controller.value >= 0.9) {
                  currentStep = 2;
                }

                return Positioned(
                  top: 100,

                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(milliseconds: 100),
                    child: _buildStepper(currentStep),
                  ),
                );
              },
            ),

            //first frame Blue Oval
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryOpacity = blueOvalAnim.value;
                final exitOpacity = 1.0 - blueOvalExitAnim.value;

                final combinedOpacity = (entryOpacity * exitOpacity).clamp(
                  0.0,
                  1.0,
                );

                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: combinedOpacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirBlueOval.path),
            ),
            //white shade
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entry = bottomWhiteShateAnim.value; // 0 → 1
                final exit = bottomWhiteShateExitAnim.value; // 0 → 1

                final opacity = (entry * (1 - exit)).clamp(0.0, 1.0);

                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirWhiteCurve.path),
            ),

            // first frame Bottom Green
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Entry: slide in from below
                final entryOffset =
                    (1 - bottomGreenAnim.value) * size.height * 0.15;

                // Exit: slide further downward
                final exitOffset =
                    -bottomGreenExitAnim.value * size.height * 0.1;

                // Combined offset
                final offset = -entryOffset + exitOffset;

                return Positioned(
                  bottom: offset,
                  left: 0,
                  right: 0,
                  child: child!,
                );
              },
              child: Image.asset(Assets.vectors.affirGreenBottom.path),
            ),

            //bottom Green Layer
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = bottomGreenLayerAnim.value.clamp(0.0, 1.0);
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirBottomGreenLayer.path),
            ),

            // Red Background
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Blend in and out
                final double opacityIn = redBackAnim.value;
                final double opacityOut = 1.0 - redBackExitAnim.value;
                final double opacity = (opacityIn * opacityOut).clamp(0.0, 1.0);

                // Slide-in from right (entry)
                final double offsetIn =
                    (1 - redBackAnim.value) * size.width * 0.15;

                // Slide-out to right (exit)
                final double offsetOut =
                    redBackExitAnim.value * size.width * 0.15;

                final double totalOffset = offsetIn + offsetOut;

                return Positioned(
                  left: 0,
                  right: -totalOffset,
                  bottom: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirRedBackg.path),
            ),

            // Bottom Left Leafs
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = leftLeafAnim.value.clamp(0.0, 1.0);
                final offset = (1 - leftLeafAnim.value) * size.width * 0.15;
                return Positioned(
                  bottom: 0,
                  left: -offset,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: SvgPicture.asset(Assets.vectors.affirBottomLeftLeafs),
            ),

            // Bottom Right Leafs
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryOffset =
                    (1 - rightLeafAnim.value) * size.width * 0.15;
                final exitOffset = rightLeafExitAnim.value * size.width * 0.3;
                final totalOffset = entryOffset + exitOffset;

                return Positioned(
                  bottom: 0,
                  right: -totalOffset,
                  left: 0,
                  child: Opacity(
                    opacity: 1 - rightLeafExitAnim.value,
                    child: child!,
                  ),
                );
              },
              child: SvgPicture.asset(Assets.vectors.affirRightBottomLeafs),
            ),

            // Rainbow
            // Rainbow
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final initialOffset =
                    (1 - rainbowAnim.value) * size.height * 0.9;
                final liftOffset = -20 * rainbowLiftAnim.value;
                final exitOffset = rainbowExitAnim.value * size.height * 0.5;

                final totalOffset = initialOffset + liftOffset - exitOffset;

                final scale = 0.95 + 0.1 * rainbowAnim.value;
                final leftOffset = -200.0 * rainbowLiftAnim.value;

                return Positioned(
                  bottom: -totalOffset,
                  left: leftOffset,
                  right: 0,
                  child: Transform.scale(scale: scale, child: child!),
                );
              },
              child: SvgPicture.asset(
                Assets.vectors.affirRainbow,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),

            //center boy
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double start = -size.height;
                final double end = 75.0;
                final double entryBottom =
                    start + (end - start) * centerBoyAnim.value;

                // Add exit: move down by 300px when exiting
                final double exitOffset =
                    centerBoyExitAnim.value * size.height * 0.5;

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: entryBottom - exitOffset,
                  child: Opacity(
                    opacity: 1 - centerBoyExitAnim.value,
                    child: child!,
                  ),
                );
              },
              child: SizedBox(
                width: 160,
                height: 300,
                child: Image.asset(
                  Assets.vectors.centerBoy1.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // yellow sun
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryValue = sunAnim.value;
                final exitValue = sunExitAnim.value;

                // Opacity fades out
                final opacity = (entryValue * (1 - exitValue)).clamp(0.0, 1.0);

                // Movement: moves upward slightly while fading out
                final offset =
                    (entryValue - exitValue * 0.5) * size.height * 0.1;

                return Positioned(
                  top: offset,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirSun.path),
            ),

            //sun return
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryValue = sun2Anim.value;
                final exitValue = sun2ExitAnim.value;

                // Opacity fades out
                final opacity = (entryValue).clamp(0.0, 1.0);

                // Movement: moves upward slightly while fading out
                final offset =
                    (entryValue - exitValue * 2.5) * size.height * 0.1;

                return Positioned(
                  top: offset,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirSun.path),
            ),

            // birds flying lottie
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final exitValue = sunExitAnim.value;
                final opacity = (1.0 - exitValue).clamp(0.0, 1.0);
                final offset = exitValue * size.height * 0.1;

                return Positioned(
                  top: size.height * 0.3 - offset,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Lottie.asset(
                Assets.vectors.birdsFlying,
                controller: _birdsLottieController,
                onLoaded: (composition) {
                  _birdsLottieController.duration = composition.duration;
                },
              ),
            ),

            //one bird lottie
            Positioned(
              bottom: size.height * 0.3,
              left: 150,
              right: 0,
              child: AnimatedScale(
                duration: Duration(milliseconds: 500),
                scale: 2.5,
                curve: Curves.fastOutSlowIn,
                child: Lottie.asset(
                  Assets.vectors.birdFlying,
                  controller: _birdLottieController,
                  onLoaded: (composition) {
                    log('Bird Lottie loaded: ${composition.duration}');
                    _birdLottieController.duration = composition.duration;
                  },
                ),
              ),
            ),

            // Seed
            AnimatedBuilder(
              animation: seedAnim,
              builder: (context, child) {
                final value = seedAnim.value;

                double left = size.width * 0.5 - 25; // center X
                double top = size.height * 0.7; // base Y

                if (value < 0.3) {
                  // Fast come in from left → center
                  final movePercent = value / 0.3;
                  left =
                      lerpDouble(
                        -size.width * 0.3,
                        size.width * 0.5 - 25,
                        Curves.easeOut.transform(movePercent),
                      )!;
                } else if (value < 0.6) {
                  // Pause in center — no change
                  left = size.width * 0.5 - 25;
                  top = size.height * 0.7;
                } else {
                  // Drop down
                  final dropPercent = (value - 0.6) / 0.4;
                  top =
                      size.height * 0.7 +
                      Curves.easeIn.transform(dropPercent) * size.height;
                }

                return Positioned(left: left, top: top, child: child!);
              },
              child: SvgPicture.asset(Assets.vectors.affriSeed),
            ),

            // Phase 1 and 2
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = (1 - plantPhase1Anim.value) * 100.0;

                final fadeIn = plantPhase1Anim.value;
                final fadeOut = 1 - plantPhaseExitAnim.value;
                final opacity = (fadeIn * fadeOut).clamp(0.0, 1.0);

                final currentPhase =
                    _controller.value >= 0.8
                        ? SvgPicture.asset(
                          key: const ValueKey(2),
                          Assets.vectors.plantPhase2,
                        )
                        : SvgPicture.asset(
                          key: const ValueKey(1),
                          Assets.vectors.plantPhase1,
                        );

                return Positioned(
                  bottom: -offset,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opacity,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: currentPhase,
                    ),
                  ),
                );
              },
            ),

            // plant Phase 3 and 4
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = (1 - plantPhase2Anim.value) * 100.0;

                final fadeIn = plantPhase2Anim.value;

                final opacity = (fadeIn).clamp(0.0, 1.0);

                final currentPhase =
                    _controller.value >= 0.95
                        ? SvgPicture.asset(
                          key: const ValueKey(4),
                          Assets.vectors.plantPhase4,
                        )
                        : SvgPicture.asset(
                          key: const ValueKey(3),
                          Assets.vectors.plantPhase3,
                        );

                return Positioned(
                  bottom: -offset,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opacity,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: currentPhase,
                    ),
                  ),
                );
              },
            ),

            // Bottom Flowers
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = (1 - bottomFlowersAnim.value) * 100;

                final fadeIn = bottomFlowersAnim.value;

                final opacity = (fadeIn).clamp(0.0, 1.0);

                return Positioned(
                  bottom: -offset,
                  left: 0,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child),
                );
              },
              child: Image.asset(Assets.vectors.affirFlowers.path),
            ),

            // "Listen" Image
            // AnimatedBuilder(
            //   animation: _controller,
            //   builder: (context, child) {
            //     final opacity1 = listenAppearAnim.value;
            //     final opacity2 = listen1AppearAnim.value;
            //     final opacity1Exit = 1.0 - listenAppearExitAnim.value;
            //     final opacity2Exit = 1.0 - listen1AppearExitAnim.value;

            //     final opacity = (opacity1 *
            //             opacity1Exit *
            //             opacity2 *
            //             opacity2Exit)
            //         .clamp(0.0, 1.0);

            //     return Positioned(
            //       top: size.height / 2,
            //       child: Opacity(opacity: opacity, child: child!),
            //     );
            //   },
            //   child: ListeningWidget(),
            // ),
            IntervalFadeWidget(
              controller: _controller,
              appearAnim: listenAppearAnim,
              exitAnim: listenAppearExitAnim,
              child: ListeningWidget(),
            ),
            IntervalFadeWidget(
              controller: _controller,
              appearAnim: listen1AppearAnim,
              exitAnim: listen1AppearExitAnim,
              child: ListeningWidget(),
            ),
            IntervalFadeWidget(
              controller: _controller,
              appearAnim: listen2AppearAnim,
              exitAnim: listen2AppearExitAnim,
              child: ListeningWidget(),
            ),

            // "Listen Success" Image that fades in then moves up
            SuccessListenWidget(
              controller: _controller,
              listenSuccessFadeIn: listenSuccessFadeIn,
              listenSuccessMoveUp: listenSuccessMoveUp,
            ),
            SuccessListenWidget(
              controller: _controller,
              listenSuccessFadeIn: listenSuccess1FadeIn,
              listenSuccessMoveUp: listenSuccess1MoveUp,
            ),
            SuccessListenWidget(
              controller: _controller,
              listenSuccessFadeIn: listenSuccess2FadeIn,
              listenSuccessMoveUp: listenSuccess2MoveUp,
            ),

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final value = _controller.value;

                // Find current lyric index
                final index = textLines.indexWhere(
                  (line) => value >= line.start && value <= line.end,
                );

                final currentLine = index != -1 ? textLines[index] : null;

                return currentLine != null
                    ? Positioned(
                      left: 0,
                      right: 0,
                      top: size.height * 0.3,
                      child: BuildAnimationText(
                        currentLyricIndex: index,
                        currentLyric: currentLine.text,
                      ),
                    )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 32 : 12,
          decoration: BoxDecoration(
            gradient:
                currentStep < index
                    ? null
                    : LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        HexColor('#6E40F9'),
                        HexColor('#A569FB'),
                        HexColor('#CE89FF'),
                      ],
                    ),
            color: isActive ? null : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
        );
      }),
    );
  }
}

class BuildAnimationText extends StatelessWidget {
  final int currentLyricIndex;
  final String currentLyric;
  const BuildAnimationText({
    super.key,
    required this.currentLyricIndex,
    required this.currentLyric,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Text(
          currentLyric,
          key: ValueKey(currentLyricIndex),

          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class IntervalFadeWidget extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> appearAnim;
  final Animation<double> exitAnim;

  final Widget child;

  const IntervalFadeWidget({
    super.key,
    required this.controller,

    required this.child,
    required this.appearAnim,
    required this.exitAnim,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final opacity = (appearAnim.value * (1.0 - exitAnim.value)).clamp(
          0.0,
          1.0,
        );

        if (opacity == 0.0) return const SizedBox.shrink();

        return Positioned(
          top: size.height / 2,
          child: Opacity(opacity: opacity, child: child),
        );
      },
    );
  }
}

class SuccessListenWidget extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> listenSuccessFadeIn;
  final Animation<double> listenSuccessMoveUp;

  const SuccessListenWidget({
    super.key,
    required this.controller,
    required this.listenSuccessFadeIn,
    required this.listenSuccessMoveUp,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final fadeIn = listenSuccessFadeIn.value;
        final moveUp = listenSuccessMoveUp.value;
        final opacity = (fadeIn * (1.0 - moveUp)).clamp(0.0, 1.0);
        final offset = moveUp * size.height * 0.5;

        return Positioned(
          left: 0,
          right: 0,
          top: (size.height / 2) - offset,
          child: Opacity(opacity: opacity, child: child!),
        );
      },
      child: SizedBox(
        width: 88,
        height: 88,
        child: Image.asset(Assets.vectors.listenSucess.path),
      ),
    );
  }
}



            // AnimatedBuilder(
            //   animation: _controller,
            //   builder: (context, child) {
            //     final opacity = textAnim.value * (1 - textExitAnim.value);

            //     final double start = size.height * 0.35;
            //     final double end = size.height * 0.4;

            //     final double entryOffset =
            //         (textAnim.value) * (end - start) + start;

            //     // Move it upward during exit
            //     final double exitOffset = textExitAnim.value * 60;

            //     return Positioned(
            //       top: entryOffset - exitOffset,

            //       child: AnimatedOpacity(
            //         opacity: opacity,
            //         duration: Duration(milliseconds: 500),
            //         child: child!,
            //       ),
            //     );
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     width: size.width,
            //     child: Text(
            //       'Hi Tom!',
            //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            //     ),
            //   ),
            // ),

            // AnimatedBuilder(
            //   animation: _controller,
            //   builder: (context, child) {
            //     final opacity = text2Anim.value * (1 - text2ExitAnim.value);
            //     final double start = size.height * 0.35;
            //     final double end = size.height * 0.4;

            //     final double entryOffset =
            //         (text2Anim.value) * (end - start) + start;

            //     // Move it upward during exit
            //     final double exitOffset = text2ExitAnim.value * 60;

            //     return Positioned(
            //       top: entryOffset - exitOffset,
            //       child: AnimatedOpacity(
            //         opacity: opacity,
            //         duration: Duration(milliseconds: 300),
            //         child: child!,
            //       ),
            //     );
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     width: size.width,
            //     child: Text(
            //       'Let’s do a affirmation',
            //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            //     ),
            //   ),
            // ),