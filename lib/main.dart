import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; // REQUIRED: Imports the hardware restart engine
import 'services/database_service.dart';
import 'services/music_service.dart'; // Handles your background soundtrack configurations
import 'screens/loading_screen.dart'; 

void main() async {
  // 1. Ensure the Flutter framework structural components are fully ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. FIXED: Wrapped the root application inside Phoenix to enable 5-minute cold restarts
  runApp(
    Phoenix(
      child: const EduQuest(),
    ),
  );

  // 3. Delayed Light Setup Work for Offline Isar Sandboxes
  Future.delayed(const Duration(milliseconds: 1000), () async {
    try {
      await DatabaseService.initialize();
      debugPrint("Database initialized successfully.");
    } catch (e) {
      debugPrint("Database initialization error: $e");
    }
  });
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
    // 2. Triggers the exact millisecond the player returns to the EduQuest screen window
    else if (state == AppLifecycleState.resumed) {
      BackgroundMusic.resume(); // Resumes the background loop right where it left off
      debugPrint("GLOBAL AUDIO GUARD: Player returned to EduQuest focus. Music resumed.");
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
      // FIXED: Uses the Phoenix context controller to enable full system rebirthing
      home: const EduQuestSplashScreen(), 
    );
  }
}