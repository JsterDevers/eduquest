import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; // APPLIED: Native OS Permission Engine Hook
import 'study_methods.dart';
import 'study_hub.dart';
import 'calender.dart'; 
import 'profile.dart';
import '../services/music_service.dart';
import '../widgets/ai_assistant_sheet.dart'; // APPLIED: Global AI Sheet Wrapper

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Default to Home Dashboard (Index 2)

  final List<Widget> _pages = [
    const StudyMethodsPage(), 
    const StudyHubPage(),     
    const DashboardView(),    
    const CalendarPage(),     
    const ProfilePage(),      
  ];

  @override
  void initState() {
    super.initState();
    
    // 1. TERMINATE ADVENTURE MUSIC ENGINE IMMEDIATELY UPON LOGGING IN
    BackgroundMusic.stop();

    // 2. TRIGGER PERMISSION PRIMER: Fires safely right after the screen finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotificationPermissionPrimer(context);
    });
  }

  void _playNavFeedback() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      
      // APPLIED: Wrapper targets your layout root, rendering the Meta AI orb across all sub-tabs!
      body: AIAssistantWrapper(
        child: Stack(
          children: [
            // GLOBAL DIAMOND BACKGROUND
            Positioned.fill(
              child: Image.asset(
                'assets/bg2_1.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none, 
              ),
            ),
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 85, 
        decoration: const BoxDecoration(
          color: Color(0xFFC5BAF0), 
          border: Border(
            top: BorderSide(color: Color(0xFF5A469D), width: 4), 
          ),
        ),
        child: Row(
          children: [
            _buildNavItem(0, "STUDY METHODS", Icons.emoji_objects_outlined),
            _buildDivider(),
            _buildNavItem(1, "STUDY HUB", Icons.backpack_outlined),
            _buildDivider(),
            _buildNavItem(2, "HOME", Icons.home_outlined),
            _buildDivider(),
            _buildNavItem(3, "CALENDAR", Icons.calendar_today_outlined),
            _buildDivider(),
            _buildNavItem(4, "PROFILE", Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 2,
      height: double.infinity,
      color: const Color(0x4D5A469D), 
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex != index) {
            _playNavFeedback();
            setState(() => _currentIndex = index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          color: isSelected ? const Color(0xFFEBE5FF) : Colors.transparent,     
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    const Text(
                      "◀",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF5A469D),
                        fontSize: 8,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      icon,
                      color: const Color(0xFF5A469D),
                      size: isSelected ? 28 : 24, 
                    ),
                  ),
                  if (isSelected)
                    const Text(
                      "▶",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF5A469D),
                        fontSize: 8,
                      ),
                    ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Color(0xFF5A469D),
                      fontSize: 5.5, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // CUSTOM DIALOG: Professional Permission Explainer (Permission Primer)
  void _showNotificationPermissionPrimer(BuildContext context) {
    bool isAcceptPressed = false;
    bool isDenyPressed = false;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.transparent, 
          contentPadding: EdgeInsets.zero,
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E2C4), 
                  border: Border.all(color: const Color(0xFF381B4B), width: 5),
                  boxShadow: const [
                    BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9CE9E), 
                        shape: BoxShape.rectangle,
                      ),
                      child: const Icon(
                        Icons.add_alert_outlined,
                        color: Color(0xFF753896), 
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "QUEST ALERTS PERMISSION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF381B4B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const Divider(color: Color(0xFF6B431A), thickness: 2, height: 24),
                    
                    const Text(
                      "EDUQUEST REQUESTS PRIVILEGES TO TRANSMIT LOCAL DAILY STUDY REMINDERS AND COMPLETED QUEST NOTIFICATIONS.\n\n"
                      "SECURE CORE LOG: IN ACCORDANCE WITH OUR ZERO-KNOWLEDGE ARCHITECTURE, NO TRACKING DATA IS GATHERED OR SENT EXTERNALLY. PERMISSION CAN BE REVOKED AT ANY TIME IN YOUR DEVICE SETTINGS.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF432A5E),
                        fontSize: 7,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      children: [
                        // DENY PRIVILEGES BLOCK
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setDialogState(() => isDenyPressed = true),
                            onTapUp: (_) => setDialogState(() => isDenyPressed = false),
                            onTapCancel: () => setDialogState(() => isDenyPressed = false),
                            onTap: () {
                              SystemSound.play(SystemSoundType.click);
                              Navigator.pop(context); 
                            },
                            child: AnimatedScale(
                              scale: isDenyPressed ? 0.95 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444), 
                                  border: Border.all(color: const Color(0xFF991B1B), width: 2),
                                  boxShadow: [
                                    if (!isDenyPressed)
                                      const BoxShadow(color: Color(0x59000000), offset: Offset(3, 3))
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "DENY",
                                    style: TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // ALLOW PRIVILEGES BLOCK: Seamlessly hands execution off to native hardware popups
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setDialogState(() => isAcceptPressed = true),
                            onTapUp: (_) => setDialogState(() => isAcceptPressed = false),
                            onTapCancel: () => setDialogState(() => isAcceptPressed = false),
                            onTap: () async {
                              SystemSound.play(SystemSoundType.click);
                              Navigator.pop(context); // Clears custom menu
                              
                              // APPLIED: Summons the real native OS request engine dialogue card seamlessly
                              await Permission.notification.request();
                            },
                            child: AnimatedScale(
                              scale: isAcceptPressed ? 0.95 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E), 
                                  border: Border.all(color: const Color(0xFF166534), width: 2),
                                  boxShadow: [
                                    if (!isAcceptPressed)
                                      const BoxShadow(color: Color(0x59000000), offset: Offset(3, 3))
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "ALLOW",
                                    style: TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // OVERLAPPING TOP NOTIFICATION HEADER BANNER
              Positioned(
                top: -20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF753896), 
                    border: Border.all(color: const Color(0xFF381B4B), width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, offset: Offset(3, 3)),
                    ],
                  ),
                  child: const Text(
                    "SECURITY NOTICE",
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
        ),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2C4), 
            border: Border.all(color: const Color(0xFF381B4B), width: 5),
            boxShadow: const [
              BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.stars, color: Colors.amber, size: 40),
              SizedBox(height: 16),
              Text(
                "DASHBOARD",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Color(0xFF381B4B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "WELCOME BACK, HERO!",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Color(0xFF753896),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}