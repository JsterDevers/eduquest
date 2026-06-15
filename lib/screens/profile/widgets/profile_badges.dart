import 'package:flutter/material.dart';
import '../profile_models.dart';

// PROFILE BADGES: update badge card style or badge source here.
class BadgeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool compact;
  final bool acquired;

  const BadgeItem({
    super.key,
    required this.icon,
    required this.label,
    this.compact = false,
    this.acquired = true,
  });

  // Split label into two lines if it contains a space
  List<String> _splitLabel() {
    final parts = label.split(' ');
    if (parts.length > 1) {
      return [parts[0], parts.sublist(1).join(' ')];
    }
    return [label];
  }

  @override
  Widget build(BuildContext context) {
    final lines = _splitLabel();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(compact ? 12 : 16), // FIXED: Shrunk compact padding down from 14 to 12
          decoration: BoxDecoration(
            color: acquired ? const Color(0xFFFFF6EA) : const Color(0xFFF5F3F8),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: compact ? 24 : 28, // FIXED: Scaled size down from 26 to 24 for compact layout comfort
                color: acquired
                    ? const Color(0xFFDD6B2B)
                    : const Color(0xFFB8B3D4),
              ),
              if (!acquired)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  width: compact ? 24 : 28,
                  height: compact ? 24 : 28,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8), // Shrunk spacer gap from 10 to 8
        SizedBox(
          width: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lines[0],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: compact ? 7 : 8, // FIXED: Scaled font down based on layout status
                  color: acquired
                      ? const Color(0xFF423A75)
                      : const Color(0xFF8F8BA8),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (lines.length > 1) ...[
                const SizedBox(height: 2),
                Text(
                  lines[1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: compact ? 6 : 7, // FIXED: Scaled trailing font down matching layout status
                    color: acquired
                        ? const Color(0xFF423A75)
                        : const Color(0xFF8F8BA8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileBadges extends StatelessWidget {
  final List<ProfileBadge> badges;
  final VoidCallback onSeeAll;
  final List<ProfileBadge>? allBadges;

  const ProfileBadges({
    super.key,
    required this.badges,
    required this.onSeeAll,
    this.allBadges,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Badges',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3D2F76),
              ),
            ),
            TextButton(
              onPressed: () => _showAllBadges(context),
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
        GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 0.75, // FIXED: Adjusted ratio slightly from 0.8 to provide vertical buffer space
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(badges.length, (index) {
            final badge = badges[index];
            return BadgeItem(
              icon: badge.icon,
              label: badge.label,
              compact: true,
              acquired: true,
            );
          }),
        ),
      ],
    );
  }

  void _showAllBadges(BuildContext context) {
    if (allBadges == null) {
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
        // FIXED: Wrap content inside a FractionallySizedBox to enforce clear safety layout boundaries
        return FractionallySizedBox(
          heightFactor: 0.75, // Restricts modal from breaking system container heights on small devices
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'All Badges',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3E2C78),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 0.72, // FIXED: Adjusted down from 0.8 to give split label texts absolute sizing room
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(allBadges!.length, (index) {
                      final badge = allBadges![index];
                      final isAcquired = index < badges.length;
                      return BadgeItem(
                        icon: badge.icon,
                        label: badge.label,
                        compact: true, // FIXED: Explicitly added true so it matches layout scaling profiles inside modal grid
                        acquired: isAcquired,
                      );
                    }),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}