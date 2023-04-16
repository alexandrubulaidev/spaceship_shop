import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/controller_state.dart';
import '../../../core/services.dart';
import '../../../data/repositories/spaceship_repository.dart';
import '../../../model/cart_item.dart';
import '../../../model/spaceship_shop_component.dart';
import '../../../services/shopping_service.dart';
import '../../../utils/app_localizations.dart';

enum ShopState { components, service }

extension ShopStateStepperIndex on ShopState {
  int get index {
    switch (this) {
      case ShopState.components:
        return 0;
      case ShopState.service:
        return 1;
    }
  }
}

class ShopPageController with ControllerStateMixin {
  ShopPageController() {
    unawaited(_init());
  }

  SpaceshipRepository get _repository => Services.get<SpaceshipRepository>();
  ShoppingService get _shop => Services.get<ShoppingService>();

  BehaviorSubject<ShopState> shopState = BehaviorSubject.seeded(
    ShopState.components,
  );

  BehaviorSubject<bool> fetchingComponents = BehaviorSubject.seeded(false);
  final List<SpaceshipShopComponent> _components = [];
  List<SpaceshipShopComponent> get components => List.from(_components);

  DateTime get appointmentDate => _shop.appointmentDate;
  set appointmentDate(final DateTime value) {
    _shop.appointmentDate = value;
  }

  double get totalCost => _shop.totalCost;

  int getItemCount({
    required final CartItem item,
  }) {
    return _shop.itemCount(item);
  }

  void updateItemCount({
    required final CartItem item,
    required final int count,
  }) {
    return _shop.updateCount(
      item: item,
      count: count,
    );
  }

  Future<void> _init() async {
    state.value = ControllerState.idle();
    await refreshShop();
  }

  Future<void> refreshShop() async {
    fetchingComponents.value = true;
    // add a delay so it looks like it's loading something
    await Future<void>.delayed(const Duration(seconds: 1));
    final result = await _repository.getAvailableShopComponents();
    result.when((final success) {
      _components.clear();
      _components.addAll(success);
    }, (final error) {
      state.value = ControllerState.error('Shop is unreachable'.localized);
    });
    fetchingComponents.value = false;
  }

  void showServiceDateStep() {
    shopState.value = ShopState.service;
    // maybe do something here
  }

  void showComponentsStep() {
    shopState.value = ShopState.components;
    // maybe do something here
  }
}
