import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class StudyMethodsPage extends StatefulWidget {
  const StudyMethodsPage({super.key});

  @override
  State<StudyMethodsPage> createState() => _StudyMethodsPageState();
}

class _StudyMethodsPageState extends State<StudyMethodsPage> {
  int? _selectedSpellIndex; // null = Main spell list

  // TIMER STATES (For Pomodoro Spell)
  Timer? _timer;
  int _secondsRemaining = 1500; // 25 Minutes (25 * 60)
  bool _isTimerRunning = false;

  // FLASHCARD STATES (For Active Recall Spell)
  bool _isCardFlipped = false;

  final List<Map<String, dynamic>> _spells = [
    {
      "name": "FOCUS HOURGLASS",
      "subtitle": "POMODORO SPELL",
      "icon": Icons.hourglass_empty,
      "color": const Color(0xFFD97706), // Gold/Amber
      "description": "GRIND FOR 25 MINUTES INTENSELY, THEN RECOVER WITH A 5-MINUTE REST. ENHANCES CONCENTRATION AND WST-LEVEL FOCUS.",
    },
    {
      "name": "MIND FLASHCARD",
      "subtitle": "ACTIVE RECALL",
      "icon": Icons.psychology,
      "color": const Color(0xFF3B82F6), // Blue
      "description": "ACTIVELY FORCE YOUR BRAIN TO RETRIEVE KNOWLEDGE INSTEAD OF REREADING. CHECKS IF SPELLS ARE TRULY INGRAINED IN MEMORY.",
    },
    {
      "name": "SAGE'S TOME",
      "subtitle": "FEYNMAN METHOD",
      "icon": Icons.menu_book_sharp,
      "color": const Color(0xFF753896), // Purple
      "description": "EXPLAIN A COMPLEX TOPIC IN SIMPLE FANTASY TERMS TO A NOVICE. IF YOU CANNOT SIMPLIFY IT, YOU DO NOT MASTERY IT YET.",
    },
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  // Pomodoro Timer Mechanics
  void _toggleTimer() {
    _playInteractionEffect();
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() => _isTimerRunning = false);
    } else {
      setState(() => _isTimerRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() {
            _isTimerRunning = false;
            _secondsRemaining = 1500; // Reset
          });
          HapticFeedback.vibrate(); // Solid alarm buzz
        }
      });
    }
  }

  void _resetTimer() {
    _playInteractionEffect();
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _secondsRemaining = 1500;
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minStr = minutes.toString().padLeft(2, '0');
    String secStr = seconds.toString().padLeft(2, '0');
    return "$minStr:$secStr";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Allows global pattern to show
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

          // 2. MAIN SCROLLABLE CONTAINER
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
                      // PARCHMENT CONTAINER
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 400),
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
                          child: _selectedSpellIndex == null
                              ? _buildSpellList()
                              : _buildSpellDetailView(_selectedSpellIndex!),
                        ),
                      ),

                      // OVERLAPPING TOP CHAMBER BANNER
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
                            _selectedSpellIndex == null ? "TRAINING CHAMBER" : "ACTIVE SPELL",
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.white,
                              fontSize: 11,
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

  // SCREEN 1: Spell Selector List
  Widget _buildSpellList() {
    return Column(
      key: const ValueKey("SpellList"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Center(
          child: Text(
            "EQUIP STUDY METHOD SPELLS",
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Color(0xFF432A5E),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 25),

        ...List.generate(_spells.length, (index) {
          final spell = _spells[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                _playInteractionEffect();
                setState(() {
                  _selectedSpellIndex = index;
                  _isCardFlipped = false; // Reset card flips
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9CE9E), // Darker parchment card
                  border: Border.all(color: const Color(0xFF6B431A), width: 3), // Wooden border
                ),
                child: Row(
                  children: [
                    // Icon Box
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: spell['color'],
                      child: Icon(spell['icon'], color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),

                    // Spell Meta
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spell['name'],
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF381B4B),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            spell['subtitle'],
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF753896),
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  // SCREEN 2: Interactive Spell Detail Layout (Timer & Card Flip Actions!)
  Widget _buildSpellDetailView(int index) {
    final spell = _spells[index];

    return Column(
      key: const ValueKey("SpellDetail"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        // Go Back Navigation
        GestureDetector(
          onTap: () {
            _playInteractionEffect();
            setState(() => _selectedSpellIndex = null);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9CE9E),
              border: Border.all(color: const Color(0xFF6B431A), width: 2),
            ),
            child: const Text(
              "< SPELLS",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF381B4B),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Header
        Row(
          children: [
            Icon(spell['icon'], color: spell['color'], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                spell['name'],
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: spell['color'],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const Divider(color: Color(0xFF6B431A), thickness: 2, height: 24),

        // Core Description Paragraph
        Text(
          spell['description'],
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            color: Color(0xFF432A5E),
            fontSize: 8,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        // SPELL INTERACTIVITY PORTAL
        Center(
          child: _buildInteractivePortal(index),
        ),
      ],
    );
  }

  // Dynamically loads the functional interactive widget based on selection
  Widget _buildInteractivePortal(int index) {
    if (index == 0) {
      // 1. FOCUS HOURGLASS: Interactive Pomodoro Game Timer
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE9CE9E),
          border: Border.all(color: const Color(0xFF6B431A), width: 3),
        ),
        child: Column(
          children: [
            const Text(
              "FOCUS TIMER",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF6B431A),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF381B4B),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _toggleTimer,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    color: _isTimerRunning ? Colors.redAccent : Colors.green,
                    child: Text(
                      _isTimerRunning ? "PAUSE" : "START",
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _resetTimer,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    color: Colors.grey,
                    child: const Text(
                      "RESET",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (index == 1) {
      // 2. MIND FLASHCARD: Interactive Card Flip Game
      return GestureDetector(
        onTap: () {
          _playInteractionEffect();
          setState(() => _isCardFlipped = !_isCardFlipped);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isCardFlipped ? const Color(0xFF432A5E) : const Color(0xFFE9CE9E),
            border: Border.all(color: const Color(0xFF6B431A), width: 3),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(4, 4)),
            ],
          ),
          child: Center(
            child: Text(
              _isCardFlipped
                  ? "A: RETRIEVING INFORMATION FORCES BRAIN PATHWAYS TO STRONGLY REBUILD AND ENGRAVE THE KNOWLEDGE."
                  : "Q: WHY IS RECALL MORE POWERFUL THAN REREADING?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: _isCardFlipped ? Colors.white : const Color(0xFF381B4B),
                fontSize: 8,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    } else {
      // 3. SAGE'S TOME: Checklist/Rule Tracker layout
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE9CE9E),
          border: Border.all(color: const Color(0xFF6B431A), width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "SAGE STEPS:",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF381B4B),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text("1. PICK YOUR CONCEPT TO MASTER.\n\n"
                "2. WRITE EXPLANATION AS IF TO A 10-YEAR-OLD.\n\n"
                "3. FIND GAPS WHERE YOU ARE CONFUSED.\n\n"
                "4. RUN BACK TO BOOK SOURCES TO STUDY AGAIN.", 
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF432A5E),
                fontSize: 7,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }
  }
}