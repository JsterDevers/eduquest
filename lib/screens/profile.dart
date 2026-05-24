import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';
import '../models/player.dart';
import 'start_adventure_page.dart'; // REQUIRED: Destroys navigation stacks back to entry gate

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Player? _currentPlayer;
  bool _isLoading = true;
  bool _isLogoutPressed = false;

  @override
  void initState() {
    super.initState();
    _loadHeroData();
  }

  // FIXED LOADER: Gracefully reads existing player logs directly from local collection schemas safely
  Future<void> _loadHeroData() async {
    try {
      // Pulls all registered player profiles from Isar local device storage arrays
      // DatabaseService does not expose a getPlayer method; access the Isar instance directly
      final players = await DatabaseService.isar.players.where().findAll();
      
      setState(() {
        if (players.isNotEmpty) {
          _currentPlayer = players.first; // Binds current layout view straight to your active hero profile
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("PROFILE CORE ERROR: Failed to load player specs -> $e");
      setState(() => _isLoading = false);
    }
  }

  // METHOD 1 LOGOUT METHOD: Updates SharedPreferences while leaving local DB untouched
  Future<void> _handleHeroLogout() async {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Flip session verification switches back to false
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('isFirstTimeUser', false); // Keep false so they hit Login choice, not Sign Up!

    debugPrint("SESSION ENGINE: Hero logged out safely. Isar database remains intact.");

    if (!mounted) return;

    // Purge the current navigation memory stream completely
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StartAdventurePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Allows HomePage background to show through cleanly
      body: Stack(
        children: [
          // 1. GLOBAL BACKGROUND PATTERN
          Positioned.fill(
            child: Image.asset(
              'assets/bg2_1.png', 
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none, // Keeps retro pixel pattern perfectly crisp
            ),
          ),

          // 2. SCROLLABLE CONTENT WITH FULL-WIDTH PROFILE BANNER
          SafeArea(
            bottom: false, // Allows navbar margin to breathe freely
            child: Column(
              children: [
                // FIXED HEADER: Profile Banner spans perfectly edge-to-edge
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/Profile.png', // Points to your newly uploaded profile banner asset file
                    fit: BoxFit.fitWidth, // Scales and snaps side-to-side perfectly with zero gaps
                  ),
                ),

                // SCROLLABLE BODY AREA
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      children: [
                        // OVERLAPPING FANTASY CARD
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            // MAIN PARCHMENT CARD CONTAINER
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(minHeight: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5E2C4), // Warm Parchment Cream Hex
                                border: Border.all(color: const Color(0xFF381B4B), width: 5),
                                boxShadow: const [
                                  BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                                ],
                              ),
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(color: Color(0xFF753896)),
                                    )
                                  : (_currentPlayer == null)
                                      ? const Center(
                                          child: Text(
                                            "NO HERO FOUND",
                                            style: TextStyle(fontFamily: 'PressStart2P', fontSize: 10, color: Color(0xFF381B4B)),
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 12),
                                            
                                            // ICON AVATAR HERO PORTRAIT DISPLAY
                                            const Icon(
                                              Icons.account_circle,
                                              size: 80,
                                              color: Color(0xFF432A5E),
                                            ),
                                            
                                            const SizedBox(height: 16),

                                            // DYNAMIC HERO USERNAME
                                            Text(
                                              _currentPlayer!.username.toUpperCase(), // FIXED null assertion
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: 'PressStart2P',
                                                color: Color(0xFF381B4B),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 20),
                                            const Divider(color: Color(0xFF381B4B), thickness: 2),
                                            const SizedBox(height: 16),

                                            // DYNAMIC CORE CHARACTER STATISTICS LOADOUT - FIXED: Removed null-aware check to fix compilation bugs
                                            _buildStatRow("LEVEL", "LVL ${_currentPlayer!.level}"),
                                            const SizedBox(height: 12),
                                            _buildStatRow("EXP POINTS", "${_currentPlayer!.xp} XP"),
                                            const SizedBox(height: 12),
                                            _buildStatRow("SCROLL KEY", _currentPlayer!.recoveryCode),
                                          ],
                                        ),
                            ),

                            // OVERLAPPING TOP "HERO STATUS" BANNER LABEL
                            Positioned(
                              top: -20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),

                        // METHOD 1 INTERACTIVE LOGOUT BUTTON COMPONENT
                        GestureDetector(
                          onTapDown: (_) => setState(() => _isLogoutPressed = true),
                          onTapUp: (_) => setState(() => _isLogoutPressed = false),
                          onTapCancel: () => setState(() => _isLogoutPressed = false),
                          onTap: _handleHeroLogout,
                          child: AnimatedScale(
                            scale: _isLogoutPressed ? 0.95 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF963838), // Crimson Red Game Theme Color Hex
                                border: Border.all(color: const Color(0xFF4B1B1B), width: 4),
                                boxShadow: [
                                  if (!_isLogoutPressed)
                                    const BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "LOG OUT SYSTEM",
                                  style: TextStyle(
                                    fontFamily: 'PressStart2P',
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80), // Prevents layout clipping over floating bottom navbar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // RETRO SPECS ROW BUILDER
  Widget _buildStatRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            color: Color(0xFF753896),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            color: Color(0xFF381B4B),
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}