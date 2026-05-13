import 'package:flutter/material.dart'; // REQUIRED for debugPrint
import 'package:audioplayers/audioplayers.dart';

class BackgroundMusic {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  // Loops the background soundtrack
  static Future<void> play() async {
    if (_isPlaying) return; 
    try {
      await _player.setReleaseMode(ReleaseMode.loop); 
      await _player.setVolume(0.5); 
      await _player.play(AssetSource('start to login music.mp3'));
      _isPlaying = true;
    } catch (e) {
      debugPrint("Background music failed to play: $e"); 
    }
  }

  // Terminates the track when entering the HomePage hub
  static Future<void> stop() async {
    if (!_isPlaying) return;
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint("Background music failed to stop: $e"); 
    }
  }
}