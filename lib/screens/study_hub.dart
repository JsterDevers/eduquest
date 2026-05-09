import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudyHubPage extends StatefulWidget {
  const StudyHubPage({super.key});

  @override
  State<StudyHubPage> createState() => _StudyHubPageState();
}

class _StudyHubPageState extends State<StudyHubPage> {
  int? _selectedRealmIndex; // null means viewing the main board

  // Improvised study paths/realms
  final List<Map<String, dynamic>> _realms = [
    {
      "title": "SECURITY DUNGEON",
      "subtitle": "IAS1 & CRYPTOGRAPHY",
      "icon": Icons.shield_outlined,
      "color": const Color(0xFF753896), // Purple
      "progress": 0.65, // 65% Mastery
      "quests": [
        "PRINCIPLE OF LEAST PRIVILEGE",
        "MOBILE PRIVACY AUDIT",
        "SYMMETRIC ENCRYPTION",
      ],
    },
    {
      "title": "FLUTTER CODESCAPE",
      "subtitle": "MOBILE APP DEV",
      "icon": Icons.phone_android_outlined,
      "color": const Color(0xFF3B82F6), // Blue
      "progress": 0.80, // 80% Mastery
      "quests": [
        "WIDGET TREE BASICS",
        "LOCAL STORAGE WITH ISAR",
        "RETRO UI STYLING",
      ],
    },
    {
      "title": "PARALLEL REALM",
      "subtitle": "HIGH-PERFORMANCE COMP.",
      "icon": Icons.bolt_outlined,
      "color": const Color(0xFFD97706), // Amber
      "progress": 0.40, // 40% Mastery
      "quests": [
        "DATA-LEVEL PARALLELISM",
        "DISTRIBUTED SYSTEMS",
        "GRID COMPUTING BASICS",
      ],
    },
  ];

  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

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
              filterQuality: FilterQuality.none,
            ),
          ),

          // 2. MAIN LAYOUT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // OVERLAPPING CARD STACK
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // MAIN PARCHMENT CARD
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 380),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E2C4), // Parchment Cream
                          border: Border.all(color: const Color(0xFF381B4B), width: 5),
                          borderRadius: BorderRadius.zero,
                          boxShadow: const [
                            BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _selectedRealmIndex == null
                              ? _buildRealmList()
                              : _buildQuestDetailView(_selectedRealmIndex!),
                        ),
                      ),

                      // OVERLAPPING "QUESTS" EMBLAZONED BANNER
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
                          child: Text(
                            _selectedRealmIndex == null ? "QUEST BOARD" : "ACTIVE QUESTS",
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.white,
                              fontSize: 13,
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

  // SCREEN 1: Display all Study Subjects/Realms
  Widget _buildRealmList() {
    return Column(
      key: const ValueKey("RealmList"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Center(
          child: Text(
            "SELECT A KNOWLEDGE REALM",
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Color(0xFF432A5E),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 25),

        // List of realms
        ...List.generate(_realms.length, (index) {
          final realm = _realms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                _playInteractionEffect();
                setState(() => _selectedRealmIndex = index);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9CE9E), // Darker parchment card
                  border: Border.all(color: const Color(0xFF6B431A), width: 3), // Wooden border
                ),
                child: Row(
                  children: [
                    // Realm Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: realm['color'],
                      child: Icon(realm['icon'], color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),

                    // Realm Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            realm['title'],
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF381B4B),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            realm['subtitle'],
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.black45,
                              fontSize: 7,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Custom Pixel Progress Bar
                          _buildPixelProgressBar(realm['progress'], realm['color']),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Color(0xFF6B431A)),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // SCREEN 2: View specific Quests/Topics inside the selected Realm
  Widget _buildQuestDetailView(int index) {
    final realm = _realms[index];
    final List<String> quests = realm['quests'];

    return Column(
      key: const ValueKey("QuestDetail"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        // Go Back Button
        GestureDetector(
          onTap: () {
            _playInteractionEffect();
            setState(() => _selectedRealmIndex = null);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9CE9E),
              border: Border.all(color: const Color(0xFF6B431A), width: 2),
            ),
            child: const Text(
              "< BACK",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF381B4B),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Realm Title Header
        Row(
          children: [
            Icon(realm['icon'], color: realm['color'], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                realm['title'],
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: realm['color'],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const Divider(color: Color(0xFF6B431A), thickness: 2, height: 24),

        // Subquests List
        ...quests.map((quest) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                border: Border.all(color: const Color(0xFF6B431A).withOpacity(0.5), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_arrow, color: Color(0xFF753896), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quest,
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF381B4B),
                        fontSize: 8,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // HELPER: Custom Pixel Progress Bar Builder
  Widget _buildPixelProgressBar(double value, Color color) {
    return Stack(
      children: [
        // Background track
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: const Color(0xFF6B431A), width: 2),
          ),
        ),
        // Progress fill
        FractionallySizedBox(
          widthFactor: value,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.transparent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}