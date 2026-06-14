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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ===== LEVEL + XP OVERLAP =====
              SizedBox(
                width: screenW * 0.42,
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

                    // LEVEL (overlapping)
                    Positioned(
                      left: 0,
                      top: -2,
                      child: Container(
                        width: screenW * 0.10,
                        height: 31,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 113, 6, 213),
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

              const SizedBox(width: 6),

              // ===== COINS =====
              _hudStat(
                icon: 'assets/coin.png',
                width: screenW * 0.28,
                child: _fitText(stats.coins.toString()),
              ),

              const SizedBox(width: 12),

              // ===== STREAK =====
              Padding(
                padding: const EdgeInsets.only(right: 10), // adjust value here
                child: _hudStat(
                  icon: 'assets/streak.png',
                  width: screenW * 0.18,
                  child: _fitText(stats.streak.toString()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}