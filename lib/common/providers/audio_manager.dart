import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class AudioManager extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  String? currentTitle;
  String? currentArtist;

  bool get isPlaying => player.playing;

  Future<void> play(String url, {String? title, String? artist}) async {
    currentTitle = title;
    currentArtist = artist;
    await player.setUrl(url);
    await player.play();
    notifyListeners();
  }

  void pause() {
    player.pause();
    notifyListeners();
  }

  void resume() {
    player.play();
    notifyListeners();
  }

  void stop() {
    player.stop();
    notifyListeners();
  }

  void disposePlayer() {
    player.dispose();
  }
}
