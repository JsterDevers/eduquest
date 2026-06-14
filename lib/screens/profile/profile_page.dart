import 'package:flutter/material.dart';
import 'profile_controller.dart';
import 'profile_widgets.dart';

// PROFILE PAGE: change layout, sections, and sheet behavior here.
// Keep all main UI composition in this file and move reusable UI into widgets.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileController();
  }

  @override
  Widget build(BuildContext context) {
    // EDIT THIS: change leaderboard sample rows or replace with dynamic data.
    final leaderboard = const [
      {'position': 1, 'name': 'Sarah J', 'score': 12500, 'highlight': true},
      {'position': 2, 'name': 'Mike D', 'score': 11200, 'highlight': false},
      {'position': 3, 'name': 'Alex K', 'score': 9800, 'highlight': false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1FF),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeader(
                  controller: controller,
                  onMarketTap: showMarketSelection,
                  onSettingsTap: showSettingsSheet,
                  onCustomizeTap: showCustomizeSheet,
                ),
                const SizedBox(height: 320),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),

                      ProfileBadges(
                        badges: controller.badges,
                        allBadges: controller.allBadges,
                        onSeeAll: () {},
                      ),

                      const SizedBox(height: 24),

                      ProfileAchievements(
                        achievements: controller.achievements,
                        allAchievements: controller.allAchievements,
                        onSeeAll: () {},
                      ),

                      const SizedBox(height: 24),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ProfileLeaderboard(leaderboard: leaderboard),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: ProfileSummary(
                controller: controller,
                onCustomizeTap: showCustomizeSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSettingsSheet() {
    showModalBottomSheet(
      context: context,
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
                'Profile Settings',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3E2C78),
                ),
              ),
              const SizedBox(height: 18),
              const ListTile(
                leading: Icon(Icons.notifications_active_outlined),
                title: Text(
                  'Notifications',
                  style: TextStyle(fontFamily: 'PressStart2P', fontSize: 8),
                ),
                subtitle: Text(
                  'Activity, reminders, and rewards',
                  style: TextStyle(fontFamily: 'PressStart2P', fontSize: 8),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.person_outline),
                title: Text(
                  'Account',
                  style: TextStyle(fontFamily: 'PressStart2P', fontSize: 8),
                ),
                subtitle: Text(
                  'Manage your profile and privacy',
                  style: TextStyle(fontFamily: 'PressStart2P', fontSize: 8),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.palette_outlined),
                title: Text(
                  'Theme',
                  style: TextStyle(fontFamily: 'PressStart2P', fontSize: 8),
                ),
                subtitle: Text(
                  'Switch between light and dark style',
                  style: TextStyle(fontFamily: 'PressStart2P', fontSize: 8),
                ),
              ),
              const SizedBox(height: 18),
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
                    'Done',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 8,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void showMarketSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ProfileMarketSheet(
          controller: controller,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void showCustomizeSheet() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: 420,
            ),
            child: ProfileCustomizeSheet(
              controller: controller,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }
}