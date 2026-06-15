import 'package:flutter/material.dart';
import '../services/player_stats.dart';

class PlayerStatsDisplay extends StatelessWidget {
  const PlayerStatsDisplay({super.key});

  Widget _hudStat({
    required Widget child,
    required String icon,
    required double width,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1C2E),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(child: child),
        ),
        Positioned(
          right: -10,
          top: 1,
          child: Image.asset(icon, width: 24, height: 24),
        ),
      ],
    );
  }

  Widget _fitText(String value) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Text(
          value,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = PlayerStats.instance;

    return AnimatedBuilder(
      animation: stats,
      builder: (context, child) {
        final xpProgress = stats.xpTarget > 0
            ? stats.xpCurrent / stats.xpTarget
            : 0.0;

        double screenW = MediaQuery.of(context).size.width;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // ===== LEVEL + XP OVERLAP (FIXED: Wrapped in Expanded so it handles the layout flexibility) =====
              Expanded(
                child: SizedBox(
                  height: 26,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // XP BAR
                      Positioned.fill(
                        child: Container(
                          height: 26,
                          margin: const EdgeInsets.only(left: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16202E),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: xpProgress,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 113, 6, 213),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${stats.xpCurrent}/${stats.xpTarget}',
                                  style: const TextStyle(
                                    fontFamily: 'PressStart2P',
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // LEVEL BADGE
                      Positioned(
                        left: 0,
                        top: -2,
                        child: Container(
                          width: screenW * 0.10,
                          height: 31,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 113, 6, 213),
                            border: Border.all(
                              color: const Color.fromARGB(255, 57, 0, 84),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${stats.level}',
                              style: const TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16), // Clear gap spacing separating bars from icons

              // ===== COINS (FIXED: Removed Expanded so it stays tight against the streak) =====
              _hudStat(
                icon: 'assets/coin.png',
                width: screenW * 0.24, 
                child: _fitText(stats.coins.toString()),
              ),

              const SizedBox(width: 16), // Spacing between coin box and streak box

              // ===== STREAK =====
              _hudStat(
                icon: 'assets/streak.png',
                width: screenW * 0.16, 
                child: _fitText(stats.streak.toString()),
              ),
              
              const SizedBox(width: 8), // Tiny padding margin safe zone on the right edge
            ],
          ),
        );
      },
    );
  }
}