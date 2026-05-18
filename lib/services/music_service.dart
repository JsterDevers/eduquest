import 'package:flutter/material.dart'; // REQUIRED for debugPrint
import 'package:audioplayers/audioplayers.dart';

class BackgroundMusic {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  /// Starts the background audio file using an explicit modern asset channel path
  static Future<void> play() async {
    if (_isPlaying) return; 
    try {
      _isPlaying = true; // Set early to prevent double-triggering race conditions

      // FIXED: Separating the source assignment from the execution block 
      // forces Android 14 to properly register and lock the infinite loop modifier.
      await _player.setSource(AssetSource('start to login music.mp3'));
      await _player.setReleaseMode(ReleaseMode.loop); 
      await _player.setVolume(0.5); 
      await _player.resume(); // Bootstraps the audio engine safely
      
      debugPrint("AUDIO SERVICE: Core loop initialized safely at 50% volume.");
    } catch (e) {
      _isPlaying = false;
      debugPrint("Background music failed to play: $e"); 
    }
  }

  /// Terminates the track entirely when crossing the threshold into the HomePage hub
  static Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false; // Soft reset state tracking toggles cleanly
      debugPrint("AUDIO SERVICE: Sound engine fully stopped for HomePage silence.");
    } catch (e) {
      debugPrint("Background music failed to stop: $e");
    }
  }

  /// Pauses the background soundtrack safely without changing the application state flag
  static Future<void> pause() async {
    if (!_isPlaying) return;
    try {
      await _player.pause();
      debugPrint("AUDIO SERVICE: Hardware playback suspended dynamically.");
    } catch (e) {
      debugPrint("Background music failed to pause: $e");
    }
  }

  /// Resumes the background soundtrack if it was actively running before losing window focus
  static Future<void> resume() async {
    try {
      // FIXED: Only resume if the engine was intentionally playing music before minimizing.
      // This protects your HomePage from accidentally unmuting itself when returning to focus!
      if (_isPlaying) {
        await _player.resume();
        debugPrint("AUDIO SERVICE: Hardware playback restored seamlessly.");
      }
    } catch (e) {
      debugPrint("Background music failed to resume: $e");
    }
  }
}