import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'screens/loading_screen.dart'; 

void main() async {
  // 1. Ensure the Flutter framework is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Start the App Immediately
  // This draws the first frame (Loading Screen) to avoid the black screen hang.
  runApp(const EduQuest());

  // 3. Delayed Heavy Work
  // We wait 1 second to let the animation and sound start smoothly 
  // before the CPU begins the heavy Isar initialization.
  Future.delayed(const Duration(milliseconds: 1000), () async {
    try {
      await DatabaseService.initialize();
      debugPrint("Database initialized successfully.");
    } catch (e) {
      debugPrint("Database initialization error: $e");
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