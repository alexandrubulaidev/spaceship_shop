import '../core/services.dart';
import '../data/repositories/spaceship_repository.dart';
import '../model/cart_item.dart';

class ShoppingService {
  final Cart _cart = Cart();
  DateTime _appointmentDate = DateTime.now();

  SpaceshipRepository get _repository => Services.get<SpaceshipRepository>();

  // ignore: unnecessary_getters_setters
  DateTime get appointmentDate => _appointmentDate;
  set appointmentDate(final DateTime value) {
    // maybe do something here
    _appointmentDate = value;
  }

  int itemCount(final CartItem item) {
    for (final cartItemSet in _cart.itemsSets) {
      if (cartItemSet.item.id == item.id) {
        return cartItemSet.count;
      }
    }
    return 0;
  }

  void updateCount({
    required final CartItem item,
    required final int count,
  }) {
    var added = false;
    for (final cartItemSet in _cart.itemsSets) {
      if (cartItemSet.item.id == item.id) {
        cartItemSet.count = count;
        added = true;
      }
    }
    if (!added && count > 0) {
      _cart.itemsSets.add(
        CartItemSet(
          item: item,
          count: count,
        ),
      );
    }
    _cart.itemsSets.removeWhere((final element) => element.count <= 0);
  }

  double get totalCost => _cart.getTotalCost();

  void clearCart() {
    _cart.itemsSets.clear();
  }
}

class Cart {
  final List<CartItemSet> itemsSets = [];

  double getTotalCost() {
    var totalCost = 0.0;
    for (final itemSet in itemsSets) {
      totalCost += itemSet.item.price * itemSet.count;
    }
    return totalCost;
  }
}

class CartItemSet {
  CartItemSet({
    required this.item,
    required this.count,
  });

  final CartItem item;
  int count;
}
