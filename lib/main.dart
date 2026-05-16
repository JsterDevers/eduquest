import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'services/offline_ai_service.dart'; // APPLIED: Linked local AI service configuration
import 'screens/loading_screen.dart'; 

void main() async {
  // 1. Ensure the Flutter framework is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Start the App Immediately
  // This draws the first frame (Loading Screen) to avoid the black screen hang.
  runApp(const EduQuest());

  // 3. Delayed Heavy Setup Work
  // We wait 1 second to let the animation and sound start smoothly 
  // before the CPU begins processing heavy local database and AI initializations.
  Future.delayed(const Duration(milliseconds: 1000), () async {
    // A. INITIALIZE OFFLINE DATA CORE
    try {
      await DatabaseService.initialize();
      debugPrint("Database initialized successfully.");
    } catch (e) {
      debugPrint("Database initialization error: $e");
    }

    // B. INITIALIZE OFFLINE AI INFRASTRUCTURE CORE
    try {
      OfflineAiService.initializeEngine((progress) {
        // FIXED: Removed the '* 100' multiplier so your progress tracks accurately from 0% to 100%
        debugPrint("EDUQUEST AI SYSTEM MATRIX LOADING: ${progress.toStringAsFixed(0)}%");
      });
    } catch (e) {
      debugPrint("AI Core system boot error: $e");
    }
  });
}

class EduQuest extends StatelessWidget {
  const EduQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduQuest',
      theme: ThemeData(
        // Using purple as the primary theme to match your style
        primarySwatch: Colors.purple,
      ),
      // Directs to your synced 3-second loading screen
      home: const EduQuestSplashScreen(), 
    );
  }
}