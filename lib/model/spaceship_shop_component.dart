import 'cart_item.dart';
import 'spaceship_component.dart';

class SpaceshipShopComponent implements CartItem {
  SpaceshipShopComponent({
    required this.id,
    required this.type,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.price,
    this.picture,
  });

  factory SpaceshipShopComponent.fromMap(final Map<String, dynamic> map) {
    return SpaceshipShopComponent(
      id: (map['id'] as num).toInt(),
      year: (map['year'] as num).toInt(),
      price: (map['price'] as num).toDouble(),
      picture: map['picture'],
      type: map['type'],
      model: map['model'],
      manufacturer: map['manufacturer'],
    );
  }

  @override
  final int id;
  final String? picture;
  final String type;
  final String manufacturer;
  final String model;
  final int year;
  @override
  final double price;
}

extension SpaceshipShopComponentConverter on SpaceshipShopComponent {
  SpaceshipComponent toSpaceshipComponent() {
    return SpaceshipComponent(
      manufacturer: manufacturer,
      type: type,
      model: model,
      picture: picture,
    );
  }
}
