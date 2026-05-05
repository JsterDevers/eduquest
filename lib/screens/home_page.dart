import 'package:flutter/material.dart';

// Your actual game pages
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF1A0B2E),
    body: Center(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18))),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Start at Dashboard (Index 2)

  final List<Widget> _pages = [
    const PlaceholderPage("Study Methods"),
    const PlaceholderPage("Study Hub"),
    const DashboardView(), // Index 2: The actual Home content
    const PlaceholderPage("Calendar"),
    const PlaceholderPage("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Stack(
          children: [
            // Safe Nav Bar Background
            Positioned.fill(
              child: Image.asset(
                'assets/navbar.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.none,
                // Prevents crash if navbar.png is missing
                errorBuilder: (context, error, stack) => Container(color: Colors.black),
              ),
            ),
            // Invisible touch areas for the 5 icons
            Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: Container(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate widget for the Dashboard view to keep things clean
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("DASHBOARD READY", 
        style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
    );
  }
}