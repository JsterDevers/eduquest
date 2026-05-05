import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'screens/loading_screen.dart';

void main() async {
  // 1. Lock in the Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. DRAW THE UI IMMEDIATELY
  // This puts your LoadingScreen on the screen right now.
  runApp(const EduQuest());

  // 3. THE DELAY: Give the app 1 second to "breathe"
  // This ensures the black screen is replaced by your UI 
  // before the heavy database work starts.
  Future.delayed(const Duration(seconds: 1), () {
    DatabaseService.initialize();
  });
}

class EduQuest extends StatelessWidget {
  const EduQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduQuest',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const EduQuestSplashScreen(), 
    );
  }
}