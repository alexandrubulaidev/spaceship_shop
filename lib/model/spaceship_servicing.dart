import 'cart_item.dart';

class SpaceshipServicing implements CartItem {
  SpaceshipServicing({
    required this.id,
    required this.idStation,
    required this.price,
  });

  factory SpaceshipServicing.fromMap(final Map<String, dynamic> map) {
    return SpaceshipServicing(
      id: (map['id'] as num).toInt(),
      idStation: (map['idStation'] as num).toInt(),
      price: (map['price'] as num).toDouble(),
    );
  }

  @override
  final int id;
  final int idStation;
  @override
  final double price;
}
