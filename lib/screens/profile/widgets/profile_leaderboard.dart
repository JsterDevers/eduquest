import 'package:flutter/material.dart';

// PROFILE LEADERBOARD: edit leaderboard layout and row styling in this file.
class LeaderRow extends StatelessWidget {
  final int position;
  final String name;
  final int score;
  final bool highlight;

  const LeaderRow({
    super.key,
    required this.position,
    required this.name,
    required this.score,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = highlight ? const Color(0xFFEFE8FF) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: highlight
                ? const Color(0xFF7A3FD1)
                : const Color(0xFFEEE6FF),
            child: Text(
              position.toString(),
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: highlight ? Colors.white : const Color(0xFF5D3DB7),
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                fontWeight: FontWeight.w600,
                color: Color(0xFF34286B),
                fontSize: 8,
              ),
            ),
          ),
          Text(
            '$score pts',
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              fontWeight: FontWeight.w700,
              color: Color(0xFF4B2AA7),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileLeaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;

  const ProfileLeaderboard({super.key, required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Leaderboard',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3F3078),
              ),
            ),
            Text(
              'Weekly',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xFF7D70A3),
                fontSize: 8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Column(
          children: leaderboard.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LeaderRow(
                position: entry['position'] as int,
                name: entry['name'] as String,
                score: entry['score'] as int,
                highlight: entry['highlight'] as bool,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}