import 'package:isar/isar.dart';

part 'spaceship.g.dart';

@collection
class Spaceship {
  Spaceship({
    this.manufacturer,
    this.model,
    this.name,
    this.picture,
  }) : id = Isar.autoIncrement;

  factory Spaceship.fromMap(final Map<String, dynamic> map) {
    return Spaceship(
      manufacturer: map['manufacturer'],
      model: map['model'],
      name: map['name'],
      picture: map['picture'],
    );
  }

  Id id = Isar.autoIncrement;
  String? name;
  String? picture;
  String? manufacturer;
  String? model;
}
