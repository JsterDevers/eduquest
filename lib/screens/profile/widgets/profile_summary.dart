import 'package:flutter/material.dart';
import '../../../services/player_stats.dart';
import '../profile_controller.dart';
import 'stat_card.dart';

// PROFILE SUMMARY: change avatar section, XP progress, and stat cards here.
class ProfileSummary extends StatelessWidget {
  final ProfileController controller;
  final VoidCallback onCustomizeTap;

  const ProfileSummary({
    super.key,
    required this.controller,
    required this.onCustomizeTap,
  });

  @override
  Widget build(BuildContext context) {
    final stats = PlayerStats.instance;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          left: 22,
          right: 22,
          bottom: 22,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF7F2FF),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      controller.characters[controller.selectedCharacter].icon,
                      size: 50,
                      color: controller
                          .characters[controller.selectedCharacter]
                          .color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onCustomizeTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A3EA8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Customize',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Mark Joseph Palau',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      height: 1.8,
                      color: Color(0xFF4A2F7D),
                      shadows: [
                        Shadow(
                          color: Color.fromRGBO(122, 63, 209, 0.25),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Level ${stats.level}',
                    style: const TextStyle(
                      fontSize: 8,
                      fontFamily: 'PressStart2P',
                      color: Color(0xFF6C5AA0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'XP Progress',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Color(0xFF362B5D),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: stats.xpProgress,
              minHeight: 12,
              backgroundColor: const Color(0xFFF0E6FF),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF7A3FD1)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${stats.xpCurrent}/${stats.xpTarget}',
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontWeight: FontWeight.w900,
                    fontSize: 8,
                    color: Color(0xFF3E2D72),
                  ),
                ),
                Text(
                  'Next level in ${stats.xpRemaining} XP',
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF5D4D81),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    asset: 'assets/coin.png',
                    label: stats.coins.toString(),
                    caption: 'Gold',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    asset: 'assets/streak.png',
                    label: stats.streak.toString(),
                    caption: 'Streak',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    iconData: Icons.star,
                    label: '320',
                    caption: 'Stars',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}