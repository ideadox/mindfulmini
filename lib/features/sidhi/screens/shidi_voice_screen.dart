import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/shidi_chat_provider.dart';

class ShidiVoiceScreen extends StatefulWidget {
  final ShidiChatProvider shidiChatProvider;
  const ShidiVoiceScreen({super.key, required this.shidiChatProvider});

  @override
  State<ShidiVoiceScreen> createState() => _ShidiVoiceScreenState();
}

class _ShidiVoiceScreenState extends State<ShidiVoiceScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _circularController;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool showIamListeningText = false;
  bool _isListening = false;
  bool backByButton = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 11, milliseconds: 990),
    )..repeat();
    _circularController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7, milliseconds: 707),
    )..repeat();
    initSpeech();
    super.initState();
  }

  Future<void> initSpeech() async {
    await _speech.initialize(
      onStatus: (val) {
        log('Speech status: $val');
        if (val == 'notListening') {
          setState(() {
            _controller.reset();
            _circularController.reset();
            _isListening = false;
          });
        } else if (val == 'listening') {
          setState(() {
            _isListening = true;
          });
        } else if (val == 'done') {
          if (context.mounted) {
            sl<GoRouter>().pop(false);
          }
        }
      },
      onError: (val) {
        setState(() {
          _isListening = false;
        });
      },
    );
    startListening();
  }

  bool lottieLoaded = false;
  void startListening() async {
    if (!_isListening) {
      _speech.listen(
        onResult: (val) {
          log(val.recognizedWords);
          if (val.recognizedWords.isNotEmpty) {
            final newText = val.recognizedWords.trim();

            widget.shidiChatProvider.messageController.text =
                '${widget.shidiChatProvider.messageController.text} $newText';
          }
        },
      );
      _handleListeningText();
      _playAnimation();
    }
  }

  void _handleListeningText() {
    setState(() {
      showIamListeningText = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showIamListeningText = false;
        });
      }
    });
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
    }
  }

  void _playAnimation() {
    _controller.forward(from: 0.0);
    _circularController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _circularController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(),
            child: LottieBuilder.asset(
              fit: BoxFit.cover,
              Assets.vectors.shidiChatVector,
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
                _controller.repeat();
              },
            ),
          ),

          Positioned.fill(
            child: Column(
              children: [
                const Spacer(),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: showIamListeningText ? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: Text(
                    "I’m Listening",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        sl<GoRouter>().pop(false);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black12),
                        maximumSize: Size(47, 47),
                        minimumSize: Size(47, 47),
                      ),
                      icon: Icon(Icons.close),
                    ),
                    InkWell(
                      onTap: () {
                        startListening();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(100),
                            child: LottieBuilder.asset(
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,

                              Assets.vectors.shidiCircularAnimation,
                              controller: _circularController,
                              onLoaded: (composition) {
                                _circularController.duration =
                                    composition.duration;
                                _circularController.repeat();
                              },
                            ),
                          ),
                          SvgPicture.asset(
                            height: 100,
                            width: 100,
                            Assets.vectors.shidiCircularShade,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sl<GoRouter>().pop(true);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black12),
                        maximumSize: Size(47, 47),
                        minimumSize: Size(47, 47),
                      ),
                      icon: Icon(Icons.keyboard_alt_outlined),
                    ),
                  ],
                ),

                Space.h40,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
