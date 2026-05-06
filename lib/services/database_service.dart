import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/player.dart';

class DatabaseService {
  static late Isar isar;

  // 1. Initialize the database (Run this in main.dart)
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [PlayerSchema], 
      directory: dir.path,
    );
  }

  // 2. Save or Update a player
  static Future<void> savePlayer(Player player) async {
    await isar.writeTxn(() async {
      await isar.players.put(player);
    });
  }

  // 3. NEW: Verify player credentials (Username/Password Login)
  static Future<Player?> verifyPlayer(String username, String password) async {
    return await isar.players
        .filter()
        .usernameEqualTo(username)
        .and()
        .passwordEqualTo(password)
        .findFirst();
  }

  // 4. Find a player by Secret Scroll code (Recovery logic)
  static Future<Player?> getPlayerByCode(String code) async {
    return await isar.players
        .filter()
        .recoveryCodeEqualTo(code)
        .findFirst();
  }
}