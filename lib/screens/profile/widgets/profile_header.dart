import 'package:flutter/material.dart';
import '../profile_controller.dart';

// PROFILE HEADER: update title, action buttons, or scenery tag display here.
class ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  final VoidCallback onMarketTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onCustomizeTap;

  const ProfileHeader({
    super.key,
    required this.controller,
    required this.onMarketTap,
    required this.onSettingsTap,
    required this.onCustomizeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: controller.currentGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 96), // same width as 2 IconButtons

                  Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PressStart2P',
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.storefront_outlined,
                          color: Colors.white,
                        ),
                        onPressed: onMarketTap,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                        ),
                        onPressed: onSettingsTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}