import 'package:isar/isar.dart';

// This tells Isar to generate the code for this model
part 'player.g.dart'; 

@collection
class Player {
  Id id = Isar.autoIncrement;

  // Add these missing fields
  late String username;
  late String password;
  late String recoveryCode;

  // Existing fields
  int xp = 0;
  int level = 1;
}