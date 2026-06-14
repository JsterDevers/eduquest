import 'package:flutter/foundation.dart';

// Global player stats accessible from anywhere in the app.
final PlayerStats playerStats = PlayerStats.instance;

class PlayerStats extends ChangeNotifier {
  PlayerStats._internal();

  static final PlayerStats instance = PlayerStats._internal();

  int level = 12;
  int xpCurrent = 65;
  int xpTarget = 100;
  int coins = 145660;
  int streak = 20;

  int get exp => xpCurrent;
  int get gold => coins;
  set gold(int value) => setCoins(value);

  int get xpRemaining => (xpTarget - xpCurrent).clamp(0, xpTarget);
  double get xpProgress => xpTarget > 0 ? xpCurrent / xpTarget : 0.0;

  void updateLevel(int newLevel) {
    if (level != newLevel) {
      level = newLevel;
      notifyListeners();
    }
  }

  void updateXp(int current, int target) {
    xpCurrent = current.clamp(0, target);
    xpTarget = target;
    notifyListeners();
  }

  void addXp(int amount) {
    xpCurrent = (xpCurrent + amount).clamp(0, xpTarget);
    notifyListeners();
  }

  void setCoins(int value) {
    coins = value;
    notifyListeners();
  }

  void addCoins(int amount) {
    coins = (coins + amount).clamp(0, 999999999);
    notifyListeners();
  }

  void addGold(int amount) {
    addCoins(amount);
  }

  void spendCoins(int amount) {
    coins = (coins - amount).clamp(0, 999999999);
    notifyListeners();
  }

  void spendGold(int amount) {
    spendCoins(amount);
  }

  void setStreak(int value) {
    streak = value;
    notifyListeners();
  }

  void incrementStreak() {
    streak += 1;
    notifyListeners();
  }
}