import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  
  // Improvised study tasks/quests for demonstration
  final Map<int, List<String>> _quests = {
    9: ["IAS1 MODULE QUIZ", "FLUTTER UI PRACTICE"],
    12: ["MATH EXAM PREP"],
    15: ["PORTFOLIO SUBMISSION"],
  };

  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    // Basic calendar calculations for May 2026
    final year = _selectedDate.year;
    final monthName = _getMonthName(_selectedDate.month);
    
    return Scaffold(
      backgroundColor: Colors.transparent, // Allows HomePage background to show through
      body: Stack(
        children: [
          // 1. Full-Screen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg2_1.jpg',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),

          // 2. Scrollable Content Layout
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // MAIN PARCHMENT SCROLL CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E2C4), // Match Parchment Cream
                      border: Border.all(color: const Color(0xFF381B4B), width: 5),
                      borderRadius: BorderRadius.zero,
                      boxShadow: const [
                        BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // CALENDAR HEADER (e.g., "MAY 2026")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildArrowButton(Icons.chevron_left, () {
                              _playInteractionEffect();
                              setState(() {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                              });
                            }),
                            Text(
                              "$monthName $year",
                              style: const TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Color(0xFF381B4B),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildArrowButton(Icons.chevron_right, () {
                              _playInteractionEffect();
                              setState(() {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // DAYS OF THE WEEK LABELS (S, M, T, W, T, F, S)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ["S", "M", "T", "W", "T", "F", "S"].map((day) {
                            return SizedBox(
                              width: 32,
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'PressStart2P',
                                  color: Color(0xFF753896), // Brand Purple
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const Divider(color: Color(0xFF6B431A), thickness: 2, height: 20),

                        // THE 8-BIT DATE GRID
                        _buildCalendarGrid(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // "QUEST LOG" / EVENT LIST SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21153B), // Dark Blue/Purple
                      border: Border.all(color: const Color(0xFF4C3075), width: 3),
                      boxShadow: const [
                        BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.assignment_outlined, color: Colors.amber, size: 16),
                            SizedBox(width: 8),
                            Text(
                              "QUEST LOG",
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._buildEventList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mini navigation arrows with retro feedback
  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE9CE9E),
          border: Border.all(color: const Color(0xFF6B431A), width: 2),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF381B4B)),
      ),
    );
  }

  // Custom calculation grid for monthly dates
  Widget _buildCalendarGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOffset = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday % 7;

    List<Widget> dayTiles = [];

    // Empty spacers for days leading up to the 1st of the month
    for (int i = 0; i < firstDayOffset; i++) {
      dayTiles.add(const SizedBox(width: 32, height: 32));
    }

    // Interactive date tile generator
    for (int day = 1; day <= daysInMonth; day++) {
      final hasQuest = _quests.containsKey(day) && _selectedDate.month == 5 && _selectedDate.year == 2026;
      final isToday = day == DateTime.now().day && _selectedDate.month == DateTime.now().month && _selectedDate.year == DateTime.now().year;

      dayTiles.add(
        GestureDetector(
          onTap: () {
            _playInteractionEffect();
            // Optional: Set date select action here
          },
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF753896) : Colors.transparent,
              border: hasQuest 
                  ? Border.all(color: Colors.amber, width: 2) 
                  : null,
            ),
            child: Text(
              "$day",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: isToday 
                    ? Colors.white 
                    : (hasQuest ? Colors.amber : const Color(0xFF381B4B)),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    // Grid rendering container
    return Wrap(
      spacing: 6,
      runSpacing: 10,
      children: dayTiles,
    );
  }

  // Event list builder
  List<Widget> _buildEventList() {
    // Show events for May 2026 demonstration
    if (_selectedDate.month == 5 && _selectedDate.year == 2026) {
      List<Widget> list = [];
      _quests.forEach((day, tasks) {
        for (var task in tasks) {
          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Text("• ", style: TextStyle(color: Colors.white, fontFamily: 'PressStart2P', fontSize: 8)),
                  Expanded(
                    child: Text(
                      "MAY $day: $task",
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Colors.white70,
                        fontSize: 8,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
      return list;
    }

    return [
      const Text(
        "NO QUESTS ACTIVE FOR THIS MONTH.",
        style: TextStyle(
          fontFamily: 'PressStart2P',
          color: Colors.white38,
          fontSize: 7,
        ),
      )
    ];
  }

  String _getMonthName(int month) {
    const months = [
      "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
      "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
    ];
    return months[month - 1];
  }
}