import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/providers/speech_provider.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../providers/shidi_chat_provider.dart';

class ShidiVoiceScreen extends StatefulWidget {
  final ShidiChatProvider shidiChatProvider;
  const ShidiVoiceScreen({super.key, required this.shidiChatProvider});

  @override
  State<ShidiVoiceScreen> createState() => _ShidiVoiceScreenState();
}

class _ShidiVoiceScreenState extends State<ShidiVoiceScreen>
    with SingleTickerProviderStateMixin {
  // bool _showText = false;

  @override
  void initState() {
    super.initState();

    // // Fade in the text
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   setState(() {
    //     _showText = true;
    //   });

    //   // Then fade it out after 2 seconds
    //   Future.delayed(const Duration(seconds: 2), () {
    //     if (mounted) {
    //       setState(() {
    //         _showText = false;
    //       });
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) =>
              SpeechProvider()
                ..initSpeech()
                ..startListening(),
      child: Scaffold(
        body: Consumer<SpeechProvider>(
          builder: (context, provider, _) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Assets.vectors.a.path),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  // "I'm Listening" with fade in and out
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: provider.showIamListeningText ? 1.0 : 0.0,
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
                      Image.asset(Assets.images.aiChat.path),
                      IconButton(
                        onPressed: () {
                          widget.shidiChatProvider.messageController.text =
                              provider.textController.text;
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
                  Space.h40,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
