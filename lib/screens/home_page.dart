import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 2; // Start at Dashboard (Index 2)
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    // Animates the floating books in the background
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: [
          // 1. PURE CODE BACKGROUND
          Positioned.fill(
            child: CustomPaint(
              painter: PixelLibraryPainter(),
            ),
          ),

          // 2. MOVING OBJECTS (Floating Books)
          _buildFloatingBook(top: 100, right: 40, delay: 0.0),
          _buildFloatingBook(bottom: 150, left: 30, delay: 0.5),

          // 3. MAIN CONTENT
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ],
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
                errorBuilder: (context, error, stack) => Container(color: Colors.black),
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

  // Floating Book Animation Helper
  Widget _buildFloatingBook({double? top, double? bottom, double? left, double? right, required double delay}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          // Sine wave formula for smooth vertical movement
          double offset = math.sin((_floatController.value + delay) * math.pi * 2) * 12;
          return Transform.translate(
            offset: Offset(0, offset),
            child: Icon(Icons.menu_book, color: const Color(0xFFB983FF).withValues(alpha: 0.4), size: 30),
          );
        },
      ),
    );
  }
}

// THE PURE CODE BACKGROUND PAINTER
class PixelLibraryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    double cellSize = 20.0;
    
    // Draw Background Grid Pattern
    for (double i = 0; i < size.width; i += cellSize) {
      for (double j = 0; j < size.height; j += cellSize) {
        if ((i + j) % (cellSize * 4) == 0) {
          paint.color = const Color(0xFF2D1B4E).withValues(alpha: 0.2);
          canvas.drawRect(Rect.fromLTWH(i, j, cellSize, cellSize), paint);
        }
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("DASHBOARD READY", 
        style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(title, style: const TextStyle(color: Colors.white60, fontSize: 18)),
  );
}