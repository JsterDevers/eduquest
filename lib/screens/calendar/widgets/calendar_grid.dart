import 'package:flutter/material.dart';
import '../calendar_controller.dart';

class CalendarGrid extends StatelessWidget {
  final CalendarController controller;
  final VoidCallback onDayTap;

  const CalendarGrid({
    super.key,
    required this.controller,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = controller.daysInMonth();
    final firstDayOffset = controller.firstDayOffset();
    final today = DateTime.now();

    final dayTiles = <Widget>[];

    for (var i = 0; i < firstDayOffset; i++) {
      dayTiles.add(const SizedBox(width: 32, height: 32));
    }

    for (var day = 1; day <= daysInMonth; day++) {
      final hasQuest = controller.quests.any((entry) => entry.day == day);
      final hasDeadline = controller.hasDeadlineOnDay(day);
      final isToday =
          day == today.day &&
          controller.selectedDate.month == today.month &&
          controller.selectedDate.year == today.year;

      dayTiles.add(
        GestureDetector(
          onTap: onDayTap,
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF753896) : Colors.transparent,
              border: hasQuest
                  ? Border.all(color: Colors.amber, width: 2)
                  : (hasDeadline
                        ? Border.all(color: const Color(0xFF6B431A), width: 2)
                        : null),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: isToday
                        ? Colors.white
                        : (hasQuest ? Colors.amber : const Color(0xFF381B4B)),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasDeadline && !hasQuest)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6B431A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(spacing: 6, runSpacing: 10, children: dayTiles);
  }
}