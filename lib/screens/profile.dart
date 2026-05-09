import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Allows HomePage background to show
      body: Stack(
        children: [
          // 1. GLOBAL BACKGROUND PATTERN
          Positioned.fill(
            child: Image.asset(
              'assets/bg2_1.jpg',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none, // Keeps pixel pattern crisp
            ),
          ),

          // 2. SCROLLABLE LAYOUT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // OVERLAPPING FANTASY CARD
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // MAIN PARCHMENT CARD
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 400),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E2C4), // Warm Parchment Cream
                          border: Border.all(color: const Color(0xFF381B4B), width: 5),
                          borderRadius: BorderRadius.zero,
                          boxShadow: const [
                            BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(height: 20),
                            
                            // PLACEHOLDER FOR AVATAR / PROFILE PICTURE
                            Icon(
                              Icons.account_circle,
                              size: 80,
                              color: Color(0xFF432A5E),
                            ),
                            
                            SizedBox(height: 20),

                            // PLACEHOLDER STATUS TEXT
                            Text(
                              "HERO STATS",
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Color(0xFF432A5E),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),

                            SizedBox(height: 30),

                            // --- YOU CAN INPUT YOUR PLAYER STATS / DATABASE DATA HERE LATER ---
                            Text(
                              "[ STATUS LOADOUT PENDING... ]",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.black38,
                                fontSize: 8,
                                height: 1.6,
                              ),
                            ),
                            // -----------------------------------------------------------------
                          ],
                        ),
                      ),

                      // OVERLAPPING TOP "HERO STATUS" BANNER
                      Positioned(
                        top: -24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF753896), // Brand Purple
                            border: Border.all(color: const Color(0xFF381B4B), width: 4),
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, offset: Offset(3, 3)),
                            ],
                          ),
                          child: const Text(
                            "HERO STATUS",
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}