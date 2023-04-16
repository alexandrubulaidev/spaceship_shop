class SpaceshipStation {
  SpaceshipStation({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.serviceDuration, // minutes
    this.rating = 0,
    this.picture,
  });

  factory SpaceshipStation.fromMap(final Map<String, dynamic> map) {
    return SpaceshipStation(
      id: (map['id'] as num).toInt(),
      serviceDuration: (map['serviceDuration'] as num).toInt(),
      price: (map['price'] as num).toDouble(),
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      picture: map['picture'],
      name: map['name'],
      address: map['address'],
    );
  }

  final int id;
  final int serviceDuration;
  final String? picture;
  final String name;
  final String address;
  final double price;
  final double rating;
}
