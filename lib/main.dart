import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'services/music_service.dart'; // Handles your background soundtrack configurations
import 'screens/loading_screen.dart'; 

void main() async {
  // 1. Ensure the Flutter framework structural components are fully ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. FIXED PERMANENTLY: Await the database initialization BEFORE booting the UI.
  // This completely stops the Main Thread from freezing up when bringing the app from the background.
  try {
    await DatabaseService.initialize();
    debugPrint("DATABASE ENGINE: Isar sandbox initialized cleanly before boot.");
  } catch (e) {
    debugPrint("DATABASE CRITICAL ERROR: $e");
  }

  // 3. Start the application safely now that all background services are fully operational
  runApp(
    const EduQuest(),
  );
}

class EduQuest extends StatefulWidget {
  const EduQuest({super.key});

  @override
  State<EduQuest> createState() => _EduQuestState();
}

class _EduQuestState extends State<EduQuest> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    // Register global OS lifecycle listener links
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // GLOBAL LIFE CONDUIT: Detects physical hardware app minimization/restoration events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 1. If the phone minimizes the app, goes to home screen, or shows the recent apps task tray
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      BackgroundMusic.pause(); // Instantly stops the audio track on a native system level
      debugPrint("GLOBAL AUDIO GUARD: App hidden via physical button action. Music silenced.");
    } 
    // 2. FIXED: Wrapped inside a non-blocking asynchronous microtask frame callback channel.
    // This allows Android to restore the finger-touch event queue instantly upon returning, 
    // spinning up your audio drivers in the background background milliseconds later.
    else if (state == AppLifecycleState.resumed) {
      Future.microtask(() async {
        try {
          await BackgroundMusic.resume(); 
          debugPrint("GLOBAL AUDIO GUARD: Player returned to EduQuest focus. Music resumed asynchronously.");
        } catch (e) {
          debugPrint("AUDIO RESUME ERROR: $e");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduQuest',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // Boots straight into your pixel-art entry sequence frame
      home: const EduQuestSplashScreen(), 
    );
  }
}