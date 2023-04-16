import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/controller_state.dart';
import '../../../core/services.dart';
import '../../../data/repositories/spaceship_repository.dart';
import '../../../model/spaceship.dart';
import '../../../model/spaceship_servicing.dart';
import '../../../model/spaceship_station.dart';
import '../../../services/auth_service.dart';
import '../../../services/shopping_service.dart';
import '../../../utils/app_localizations.dart';

enum StationsSort { rating, price, time }

extension StationSortStrings on StationsSort {
  String get text {
    switch (this) {
      case StationsSort.rating:
        return 'Rating'.localized;
      case StationsSort.price:
        return 'Price'.localized;
      case StationsSort.time:
        return 'Time'.localized;
    }
  }
}

class StationsPageController with ControllerStateMixin {
  StationsPageController() {
    unawaited(_init());
  }
  final _shop = Services.get<ShoppingService>();
  final _session = Services.get<AuthService>();
  final _repository = Services.get<SpaceshipRepository>();

  Spaceship? _spaceship;
  Spaceship? get spaceship => _spaceship;

  DateTime get appointmentDate =>
      Services.get<ShoppingService>().appointmentDate;
  double get totalCost => Services.get<ShoppingService>().totalCost;

  BehaviorSubject<bool> fetchingStations = BehaviorSubject.seeded(false);
  BehaviorSubject<List<SpaceshipStation>> stations = BehaviorSubject.seeded([]);
  final List<SpaceshipStation> _stations = [];

  // filter controlls
  TextEditingController searchController = TextEditingController();
  StationsSort _sortOrder = StationsSort.rating;

  Future<void> _init() async {
    state.value = ControllerState.loading();

    _spaceship = await _session.spaceship;
    if (_spaceship == null) {
      state.value = ControllerState.error('Invalid spaceship'.localized);
    } else {
      await refreshStations();
    }
    if (state.value is! ControllerErrored) {
      state.value = ControllerState.idle();
    }

    searchController.addListener(filter);
  }

  Future<void> refreshStations() async {
    fetchingStations.value = true;
    // add a delay so it looks like it's loading something
    await Future<void>.delayed(const Duration(seconds: 1));
    final result = await _repository.getServiceStations();
    result.when((final success) {
      _stations.clear();
      _stations.addAll(success);
    }, (final error) {
      state.value = ControllerState.error('Stations areunreachable'.localized);
    });
    fetchingStations.value = false;
    filter();
  }

  void filter({
    final StationsSort? sortOrder,
  }) {
    if (sortOrder != null) {
      _sortOrder = sortOrder;
    }
    final text = searchController.text.toLowerCase();
    final filtered = _stations.where((final element) {
      return element.address.toLowerCase().contains(text) ||
          element.name.toLowerCase().contains(text);
    }).toList();
    filtered.sort((final a, final b) {
      if (_sortOrder == StationsSort.rating) {
        return b.rating.compareTo(a.rating);
      }
      if (_sortOrder == StationsSort.price) {
        return a.price.compareTo(b.price);
      }
      if (_sortOrder == StationsSort.time) {
        return a.serviceDuration.compareTo(b.serviceDuration);
      }
      return 0;
    });
    stations.value = filtered;
  }

  void confirmReservation({
    required final SpaceshipStation station,
  }) {
    final item = SpaceshipServicing(
      id: Random(DateTime.now().millisecondsSinceEpoch).nextInt(1000),
      idStation: station.id,
      price: station.price,
    );
    _shop.updateCount(item: item, count: 1);
  }
}
