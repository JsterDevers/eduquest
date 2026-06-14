import 'package:flutter/material.dart';
import '../profile_models.dart';

// PROFILE ACHIEVEMENTS: update achievement row appearance or progress style here.
class AchievementRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final int current;
  final int target;
  final Color color;

  const AchievementRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                        color: Color(0xFF3B2D74),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF6F6392),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$current/$target',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFF0E6FF),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAchievements extends StatelessWidget {
  final List<Achievement> achievements;
  final VoidCallback onSeeAll;
  final List<Achievement>? allAchievements;

  const ProfileAchievements({
    super.key,
    required this.achievements,
    required this.onSeeAll,
    this.allAchievements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3D2F76),
              ),
            ),
            TextButton(
              onPressed: () => _showAllAchievements(context),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 8,
                  color: Color(0xFF6B52A1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Column(
          children: achievements.map((achievement) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: AchievementRow(
                icon: achievement.icon,
                title: achievement.title,
                subtitle: achievement.subtitle,
                progress: achievement.progress,
                current: achievement.current,
                target: achievement.target,
                color: achievement.color,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showAllAchievements(BuildContext context) {
    if (allAchievements == null) {
      onSeeAll();
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'All Achievements',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3E2C78),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: allAchievements!.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final achievement = allAchievements![index];
                    final isAcquired = index < achievements.length;
                    return Opacity(
                      opacity: isAcquired ? 1.0 : 0.6,
                      child: AchievementRow(
                        icon: achievement.icon,
                        title: achievement.title,
                        subtitle: achievement.subtitle,
                        progress: achievement.progress,
                        current: achievement.current,
                        target: achievement.target,
                        color: achievement.color,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A3EA8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 8,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}