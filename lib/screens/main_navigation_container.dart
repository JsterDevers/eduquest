import 'package:flutter/material.dart';
import 'home_page.dart';

// Placeholder pages so the Nav Bar has somewhere to go
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text(title)));
}

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  // We start at index 2 (the Home icon in the center)
  int _currentIndex = 2;

  // The 5 pages matching your 5 Nav Icons
  final List<Widget> _pages = [
    const PlaceholderPage("Study Methods"), // Index 0
    const PlaceholderPage("Study Hub"),     // Index 1
    const HomePage(),                       // Index 2 (DASHBOARD)
    const PlaceholderPage("Calendar"),      // Index 3
    const PlaceholderPage("Profile"),       // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/navbar.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.none,
              ),
            ),
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