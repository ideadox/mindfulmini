import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/mini_audio_player/components/gradinet_slider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../../common/providers/audio_manager.dart';
import '../../../injection/injection.dart';
import '../../play visuals/screen/play_visuals.dart';

class MiniAudioPlayer extends StatelessWidget {
  const MiniAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context);
    // if (audioManager.currentTitle == null) return SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        sl<GoRouter>().pushNamed(PlayVisuals.routeName);
        // Navigator.of(
        //   context,
        // ).push(MaterialPageRoute(builder: (_) => FullScreenAudioPlayer()));
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Hero(
            tag: 'audio',
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.1,

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 217, 252, 238),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Space.w8,
                    Container(
                      height: 59,
                      width: 58,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Assets.dummy.story.path),
                        ),
                      ),
                    ),

                    Space.w8,

                    IconButton(
                      onPressed: () {
                        audioManager.isPlaying
                            ? audioManager.pause()
                            : audioManager.resume();
                      },
                      icon: Icon(
                        audioManager.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                    Space.w8,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomGradientText(text: 'Stories', fontSize: 12),
                        Text('The Mango Tree', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        audioManager.stop();
                      },
                      icon: Icon(Icons.cancel, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedGradientProgressBar(progressPercent: 0.6),
        ],
      ),
    );
  }
}
