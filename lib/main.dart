import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'services/database_service.dart';
import 'screens/start_adventure_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Start the app immediately to avoid the black screen hang
  runApp(const EduQuest());

  // Initialize DB after the first frame is drawn
  Future.microtask(() => DatabaseService.initialize());
}

class EduQuest extends StatelessWidget {
  const EduQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduQuest',
      theme: ThemeData(primarySwatch: Colors.purple),
      // Ensure this name matches the class below!
      home: const LogoSplashScreen(), 
    );
  }
}

class LogoSplashScreen extends StatefulWidget {
  const LogoSplashScreen({super.key});

  @override
  State<LogoSplashScreen> createState() => _LogoSplashScreenState();
}

class _LogoSplashScreenState extends State<LogoSplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playAndNavigate();
  }

  Future<void> _playAndNavigate() async {
    try {
      // Use 'assets/' prefix if AssetSource fails
      await _audioPlayer.play(AssetSource('startup_jingle.mp3')).timeout(
        const Duration(seconds: 2), // If it takes too long to load, skip it
        onTimeout: () => _audioPlayer.stop(),
      );
    } catch (e) {
      debugPrint("Sound could not play: $e");
    }

    // Give the user 2 seconds to see the logo
    await Future.delayed(const Duration(seconds: 2));

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
    // Adding a Container with a color ensures something is drawn immediately
    return Container(
      color: const Color(0xFF1A0B2E),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_stories, size: 80, color: Colors.amber),
              SizedBox(height: 20),
              Text("EDUQUEST", 
                style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 5)),
            ],
          ),
        ),
      ),
    );
  }
}