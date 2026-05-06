import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'start_adventure_page.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playStartupSound();
  }

  Future<void> _playStartupSound() async {
    // 1. Start playing the sound
    await _audioPlayer.play(AssetSource('startup_jingle.mp3'));

    // 2. Wait for 3 seconds (or the length of your sound)
    await Future.delayed(const Duration(seconds: 3));

    // 3. Move to the Start Adventure Page
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartAdventurePage()),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A0B2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your Game Logo
            Icon(Icons.auto_stories, size: 100, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              "PRODUCED BY\nHERO STUDIOS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 4,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}