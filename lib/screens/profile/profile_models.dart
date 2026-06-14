import 'package:flutter/material.dart';

// PROFILE MODEL DEFINITIONS: change data shape for scenery, character, badges, and achievements.
class SceneryOption {
  final String name;
  final LinearGradient gradient;

  const SceneryOption({required this.name, required this.gradient});
}

// EDIT CHARACTER TYPE: customize avatar option fields in the controller.
class CharacterOption {
  final String name;
  final IconData icon;
  final Color color;

  const CharacterOption({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CustomizationItem {
  final String id;
  final String label;
  final String assetPath;

  const CustomizationItem({
    required this.id,
    required this.label,
    required this.assetPath,
  });
}

class CustomizationCategory {
  final String name;
  final List<CustomizationItem> items;

  const CustomizationCategory({required this.name, required this.items});
}

class MarketItem {
  final String id;
  final String title;
  final String subtitle;
  final int price;
  final IconData icon;

  const MarketItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.icon,
  });
}

// EDIT BADGE TYPE: badge label and icon are defined here.
class ProfileBadge {
  final IconData icon;
  final String label;

  const ProfileBadge({required this.icon, required this.label});
}

// EDIT ACHIEVEMENT TYPE: progress entry structure for profile achievements.
class Achievement {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final int current;
  final int target;
  final Color color;

  const Achievement({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.target,
    required this.color,
  });
}