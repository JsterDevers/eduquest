import 'package:flutter/material.dart';
import '../../services/player_stats.dart';
import 'profile_models.dart';

// PROFILE CONTROLLER: use this file to edit profile data and selection state.
class ProfileController {
  int selectedScenery = 0;
  int selectedCharacter = 0;
  int selectedSkin = 0;
  int selectedClothes = 0;
  int selectedHair = 0;
  int selectedEyes = 0;
  int selectedMouth = 0;

  final Set<String> ownedCustomizationIds = {
    'skin_0',
    'clothes_0',
    'hair_0',
    'eyes_0',
    'mouth_0',
  };

  final Set<String> ownedMarketItemIds = {'scenery_0'};

  // CHANGE SCENERY OPTIONS: edit the names and gradients shown in the header.
  final List<SceneryOption> sceneryOptions = const [
    SceneryOption(
      name: 'Mystic Dawn',
      gradient: LinearGradient(
        colors: [Color(0xFF9B7CFF), Color(0xFFCF9CFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    SceneryOption(
      name: 'Forest Glade',
      gradient: LinearGradient(
        colors: [Color(0xFF6CCF97), Color(0xFF47A9A0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    SceneryOption(
      name: 'Sunset Cove',
      gradient: LinearGradient(
        colors: [Color(0xFFFFB26B), Color(0xFFEA6C7F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  ];

  // CHANGE CHARACTER OPTIONS: edit avatar icon, name, and accent color here.
  final List<CharacterOption> characters = const [
    CharacterOption(
      name: 'Luna',
      icon: Icons.auto_awesome,
      color: Color(0xFF6A3EA8),
    ),
    CharacterOption(
      name: 'Atlas',
      icon: Icons.shield,
      color: Color(0xFF3789FF),
    ),
    CharacterOption(name: 'Ivy', icon: Icons.eco, color: Color(0xFF4BBF6A)),
  ];

  final List<CustomizationCategory> customizationCategories = const [
    CustomizationCategory(
      name: 'Skin',
      items: [
        CustomizationItem(
          id: 'skin_0',
          label: 'Skin 1',
          assetPath: 'assets/Pixel version/Body (Skin)/Skin1.png',
        ),
        CustomizationItem(
          id: 'skin_1',
          label: 'Skin 2',
          assetPath: 'assets/Pixel version/Body (Skin)/Skin2.png',
        ),
        CustomizationItem(
          id: 'skin_2',
          label: 'Skin 3',
          assetPath: 'assets/Pixel version/Body (Skin)/Skin3.png',
        ),
      ],
    ),
    CustomizationCategory(
      name: 'Clothes',
      items: [
        CustomizationItem(
          id: 'clothes_0',
          label: 'Look 1',
          assetPath: 'assets/Pixel version/Clothes/clothes1.png',
        ),
        CustomizationItem(
          id: 'clothes_1',
          label: 'Look 2',
          assetPath: 'assets/Pixel version/Clothes/clothes2.png',
        ),
        CustomizationItem(
          id: 'clothes_2',
          label: 'Look 3',
          assetPath: 'assets/Pixel version/Clothes/clothes3.png',
        ),
      ],
    ),
    CustomizationCategory(
      name: 'Hair',
      items: [
        CustomizationItem(
          id: 'hair_0',
          label: 'Hair 1',
          assetPath: 'assets/Pixel version/Hair/hair1.png',
        ),
        CustomizationItem(
          id: 'hair_1',
          label: 'Hair 2',
          assetPath: 'assets/Pixel version/Hair/Hair2.png',
        ),
        CustomizationItem(
          id: 'hair_2',
          label: 'Hair 3',
          assetPath: 'assets/Pixel version/Hair/hair3.png',
        ),
        CustomizationItem(
          id: 'hair_3',
          label: 'Hair 4',
          assetPath: 'assets/Pixel version/Hair/hair4.png',
        ),
        CustomizationItem(
          id: 'hair_4',
          label: 'Hair 5',
          assetPath: 'assets/Pixel version/Hair/hair5.png',
        ),
      ],
    ),
    CustomizationCategory(
      name: 'Eyes',
      items: [
        CustomizationItem(
          id: 'eyes_0',
          label: 'Eyes 1',
          assetPath: 'assets/Pixel version/Eyes/eyes1.png',
        ),
        CustomizationItem(
          id: 'eyes_1',
          label: 'Eyes 2',
          assetPath: 'assets/Pixel version/Eyes/eyes2.png',
        ),
        CustomizationItem(
          id: 'eyes_2',
          label: 'Eyes 3',
          assetPath: 'assets/Pixel version/Eyes/eyes3.png',
        ),
        CustomizationItem(
          id: 'eyes_3',
          label: 'Eyes 4',
          assetPath: 'assets/Pixel version/Eyes/eyes4.png',
        ),
        CustomizationItem(
          id: 'eyes_4',
          label: 'Eyes 5',
          assetPath: 'assets/Pixel version/Eyes/eyes5.png',
        ),
      ],
    ),
    CustomizationCategory(
      name: 'Mouth',
      items: [
        CustomizationItem(
          id: 'mouth_0',
          label: 'Mouth 1',
          assetPath: 'assets/Pixel version/Mouth/mouth1.png',
        ),
        CustomizationItem(
          id: 'mouth_1',
          label: 'Mouth 2',
          assetPath: 'assets/Pixel version/Mouth/mouth2.png',
        ),
        CustomizationItem(
          id: 'mouth_2',
          label: 'Mouth 3',
          assetPath: 'assets/Pixel version/Mouth/mouth3.png',
        ),
        CustomizationItem(
          id: 'mouth_3',
          label: 'Mouth 4',
          assetPath: 'assets/Pixel version/Mouth/mouth4.png',
        ),
        CustomizationItem(
          id: 'mouth_4',
          label: 'Mouth 5',
          assetPath: 'assets/Pixel version/Mouth/mouth5.png',
        ),
        CustomizationItem(
          id: 'mouth_5',
          label: 'Mouth 6',
          assetPath: 'assets/Pixel version/Mouth/mouth6.png',
        ),
      ],
    ),
  ];

  final List<MarketItem> marketItems = const [
    MarketItem(
      id: 'scenery_0',
      title: 'Mystic Dawn',
      subtitle: 'Soft purple landscape',
      price: 0,
      icon: Icons.wb_sunny,
    ),
    MarketItem(
      id: 'scenery_1',
      title: 'Forest Glade',
      subtitle: 'Nature-themed scenery',
      price: 250,
      icon: Icons.park,
    ),
    MarketItem(
      id: 'scenery_2',
      title: 'Sunset Cove',
      subtitle: 'Warm evening sky',
      price: 300,
      icon: Icons.beach_access,
    ),
    MarketItem(
      id: 'clothes_1',
      title: 'Shiny Jacket',
      subtitle: 'Wearable style item',
      price: 120,
      icon: Icons.checkroom,
    ),
    MarketItem(
      id: 'hair_1',
      title: 'Cool Cut',
      subtitle: 'Stylish hair upgrade',
      price: 90,
      icon: Icons.content_cut,
    ),
    MarketItem(
      id: 'eyes_1',
      title: 'Bright Eyes',
      subtitle: 'Unique eye detail',
      price: 80,
      icon: Icons.remove_red_eye,
    ),
    MarketItem(
      id: 'mouth_1',
      title: 'Smile Pack',
      subtitle: 'Extra expression',
      price: 70,
      icon: Icons.mood,
    ),
  ];

  // CHANGE BADGE DATA: add or remove badges shown in the profile badge row.
  final List<ProfileBadge> badges = const [
    ProfileBadge(icon: Icons.local_fire_department, label: 'Streaker'),
    ProfileBadge(icon: Icons.menu_book, label: 'Bookworm'),
    ProfileBadge(icon: Icons.school, label: 'Scholar'),
    ProfileBadge(icon: Icons.bolt, label: 'Fast Learner'),
  ];

  // ALL BADGES: acquired and unacquired badges for the "See all" view.
  final List<ProfileBadge> allBadges = const [
    // Acquired badges
    ProfileBadge(icon: Icons.local_fire_department, label: 'Streaker'),
    ProfileBadge(icon: Icons.menu_book, label: 'Bookworm'),
    ProfileBadge(icon: Icons.school, label: 'Scholar'),
    ProfileBadge(icon: Icons.bolt, label: 'Fast Learner'),
    // Unacquired badges
    ProfileBadge(icon: Icons.auto_awesome, label: 'Creative'),
    ProfileBadge(icon: Icons.star, label: 'Star Power'),
    ProfileBadge(icon: Icons.pets, label: 'Animal Lover'),
    ProfileBadge(icon: Icons.music_note, label: 'Music Master'),
    ProfileBadge(icon: Icons.sports_soccer, label: 'Sports Star'),
    ProfileBadge(icon: Icons.brush, label: 'Art Expert'),
    ProfileBadge(icon: Icons.science, label: 'Science Whiz'),
    ProfileBadge(icon: Icons.language, label: 'Polyglot'),
    ProfileBadge(icon: Icons.calculate, label: 'Math Genius'),
    ProfileBadge(icon: Icons.history, label: 'History Buff'),
    ProfileBadge(icon: Icons.favorite, label: 'Heart Helper'),
  ];

  // CHANGE ACHIEVEMENT DATA: edit progress cards and achievement details here.
  final List<Achievement> achievements = const [
    Achievement(
      icon: Icons.local_fire_department,
      title: 'Streaker',
      subtitle: 'Study for a day',
      progress: 0.75,
      current: 6,
      target: 8,
      color: Color(0xFFFB9A62),
    ),
    Achievement(
      icon: Icons.menu_book,
      title: 'Bookworm',
      subtitle: 'Complete any reading study guides',
      progress: 0.38,
      current: 3,
      target: 8,
      color: Color(0xFF7C66E1),
    ),
    Achievement(
      icon: Icons.school,
      title: 'Scholar',
      subtitle: 'Finish all lessons in a chapter',
      progress: 0.55,
      current: 11,
      target: 20,
      color: Color(0xFF4BBF6A),
    ),
  ];

  // ALL ACHIEVEMENTS: acquired and unacquired achievements for the "See all" view.
  final List<Achievement> allAchievements = const [
    // Acquired achievements
    Achievement(
      icon: Icons.local_fire_department,
      title: 'Streaker',
      subtitle: 'Study for a day',
      progress: 0.75,
      current: 6,
      target: 8,
      color: Color(0xFFFB9A62),
    ),
    Achievement(
      icon: Icons.menu_book,
      title: 'Bookworm',
      subtitle: 'Complete any reading study guides',
      progress: 0.38,
      current: 3,
      target: 8,
      color: Color(0xFF7C66E1),
    ),
    Achievement(
      icon: Icons.school,
      title: 'Scholar',
      subtitle: 'Finish all lessons in a chapter',
      progress: 0.55,
      current: 11,
      target: 20,
      color: Color(0xFF4BBF6A),
    ),
    // Unacquired achievements
    Achievement(
      icon: Icons.star,
      title: 'Star Master',
      subtitle: 'Earn 100 stars total',
      progress: 0.0,
      current: 0,
      target: 100,
      color: Color(0xFFFFD700),
    ),
    Achievement(
      icon: Icons.trending_up,
      title: 'Rising Star',
      subtitle: 'Reach level 20',
      progress: 0.0,
      current: 0,
      target: 20,
      color: Color(0xFF00B4DB),
    ),
    Achievement(
      icon: Icons.bolt,
      title: 'Speed Demon',
      subtitle: 'Complete 50 lessons in one week',
      progress: 0.0,
      current: 0,
      target: 50,
      color: Color(0xFFFF6B6B),
    ),
    Achievement(
      icon: Icons.trolley,
      title: 'Champion',
      subtitle: 'Win 10 competitive quizzes',
      progress: 0.0,
      current: 0,
      target: 10,
      color: Color(0xFFFFD93D),
    ),
    Achievement(
      icon: Icons.favorite,
      title: 'Heart Breaker',
      subtitle: 'Like 50 posts on the community board',
      progress: 0.0,
      current: 0,
      target: 50,
      color: Color(0xFFFF69B4),
    ),
    Achievement(
      icon: Icons.share,
      title: 'Sharing is Caring',
      subtitle: 'Share 20 study resources',
      progress: 0.0,
      current: 0,
      target: 20,
      color: Color(0xFF6C63FF),
    ),
    Achievement(
      icon: Icons.group,
      title: 'Social Butterfly',
      subtitle: 'Join 5 study groups',
      progress: 0.0,
      current: 0,
      target: 5,
      color: Color(0xFF1ABC9C),
    ),
    Achievement(
      icon: Icons.edit,
      title: 'Author',
      subtitle: 'Write 10 study notes',
      progress: 0.0,
      current: 0,
      target: 10,
      color: Color(0xFF3498DB),
    ),
    Achievement(
      icon: Icons.check_circle,
      title: 'Perfect Score',
      subtitle: 'Get 100% on 5 quizzes',
      progress: 0.0,
      current: 0,
      target: 5,
      color: Color(0xFF2ECC71),
    ),
    Achievement(
      icon: Icons.whatshot,
      title: 'On Fire',
      subtitle: 'Maintain a 30-day study streak',
      progress: 0.0,
      current: 0,
      target: 30,
      color: Color(0xFFE74C3C),
    ),
  ];

  LinearGradient get currentGradient =>
      sceneryOptions[selectedScenery].gradient;
  String get currentScenery => sceneryOptions[selectedScenery].name;

  void updateScenery(int index) {
    selectedScenery = index;
  }

  void updateCharacter(int index) {
    selectedCharacter = index;
  }

  String get currentSkinAsset =>
      customizationCategories[0].items[selectedSkin].assetPath;
  String get currentClothesAsset =>
      customizationCategories[1].items[selectedClothes].assetPath;
  String get currentHairAsset =>
      customizationCategories[2].items[selectedHair].assetPath;
  String get currentEyesAsset =>
      customizationCategories[3].items[selectedEyes].assetPath;
  String get currentMouthAsset =>
      customizationCategories[4].items[selectedMouth].assetPath;

  int selectedIndexForCategory(String categoryName) {
    switch (categoryName) {
      case 'Skin':
        return selectedSkin;
      case 'Clothes':
        return selectedClothes;
      case 'Hair':
        return selectedHair;
      case 'Eyes':
        return selectedEyes;
      case 'Mouth':
        return selectedMouth;
    }
    return 0;
  }

  void updateCustomization(String categoryName, int index) {
    switch (categoryName) {
      case 'Skin':
        selectedSkin = index;
        break;
      case 'Clothes':
        selectedClothes = index;
        break;
      case 'Hair':
        selectedHair = index;
        break;
      case 'Eyes':
        selectedEyes = index;
        break;
      case 'Mouth':
        selectedMouth = index;
        break;
    }
  }

  bool isCustomizationOwned(String id) {
    return ownedCustomizationIds.contains(id);
  }

  bool isMarketItemOwned(String id) {
    return ownedMarketItemIds.contains(id);
  }

  void purchaseMarketItem(String id) {
    final item = marketItems.firstWhere((element) => element.id == id);
    if (PlayerStats.instance.coins >= item.price) {
      PlayerStats.instance.spendCoins(item.price);
      ownedMarketItemIds.add(id);
      if (id.startsWith('scenery_')) {
        updateSceneryById(id);
      }
    }
  }

  void updateSceneryById(String id) {
    final index = int.tryParse(id.split('_').last) ?? 0;
    if (index >= 0 && index < sceneryOptions.length) {
      selectedScenery = index;
      ownedMarketItemIds.add(id);
    }
  }

  String get currentSceneryId => 'scenery_$selectedScenery';
}