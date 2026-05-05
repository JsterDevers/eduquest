import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/player.dart'; // Import your model

class DatabaseService {
  static late Isar isar;

  // Initialize the database (Run this in main.dart)
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [PlayerSchema], // This schema comes from player.g.dart
      directory: dir.path,
    );
  }

  // Save a new player (The "Start Adventure" logic)
  static Future<void> savePlayer(Player player) async {
    await isar.writeTxn(() async {
      await isar.players.put(player);
    });
  }

  // Find a player by their Secret Scroll code (The "Recovery" logic)
  static Future<Player?> getPlayerByCode(String code) async {
    return await isar.players.filter().recoveryCodeEqualTo(code).findFirst();
  }
}