import 'package:isar/isar.dart';

part 'spaceship_component.g.dart';

@collection
class SpaceshipComponent {
  SpaceshipComponent({
    this.manufacturer,
    this.type,
    this.model,
    this.picture,
  }) : id = Isar.autoIncrement;

  factory SpaceshipComponent.fromMap(final Map<String, dynamic> map) {
    return SpaceshipComponent(
      manufacturer: map['manufacturer'],
      type: map['type'],
      model: map['model'],
      picture: map['picture'],
    );
  }

  Id id = Isar.autoIncrement;
  int? spaceshipId;
  String? picture;
  String? type;
  String? manufacturer;
  String? model;
}
