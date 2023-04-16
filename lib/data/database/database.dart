import 'package:isar/isar.dart';

import '../../model/spaceship.dart';
import '../../model/spaceship_component.dart';

// to regenerate schemas :
// flutter packages pub run build_runner build --delete-conflicting-outputs

class Database {
  // Private constructor
  Database._({required final Isar isar}) : _isar = isar;

  static Future<Database> create() async {
    final isar = await Isar.open([
      SpaceshipSchema,
      SpaceshipComponentSchema,
    ]);
    return Database._(isar: isar);
  }

  final Isar _isar;

  Future<T> save<T>(final T object) async {
    return _isar.writeTxn(() async {
      if (object is Spaceship) {
        object.id = await _isar.spaceships.put(object);
      } else if (object is SpaceshipComponent) {
        object.id = await _isar.spaceshipComponents.put(object);
      } else {
        throw DatabaseException('Unsupported database type');
      }
      return object;
    });
  }

  Future<Spaceship?> getSpaceship({
    required final int id,
  }) {
    return _isar.spaceships.get(id);
  }

  Future<List<SpaceshipComponent>> getSpaceshipComponents({
    required final int spaceshipId,
  }) {
    return _isar.spaceshipComponents
        .filter()
        .spaceshipIdEqualTo(spaceshipId)
        .findAll();
  }
}

class DatabaseException implements Exception {
  DatabaseException(this.message);
  final String message;
}
