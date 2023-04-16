import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/controller_state.dart';
import '../../../core/services.dart';
import '../../../data/repositories/spaceship_repository.dart';
import '../../../model/spaceship.dart';
import '../../../model/spaceship_component.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_localizations.dart';

class SpaceshipPageController with ControllerStateMixin {
  SpaceshipPageController() {
    unawaited(_init());
  }

  SpaceshipRepository get _spaceshipRepository =>
      Services.get<SpaceshipRepository>();
  AuthService get _session => Services.get<AuthService>();
  int? get _id => Services.get<AuthService>().spaceshipId;

  Spaceship? _spaceship;
  List<SpaceshipComponent> _components = [];

  Spaceship? get spaceship => _spaceship;
  List<SpaceshipComponent> get components => _components;

  Future<void> _init() async {
    state.value = ControllerState.loading();
    // add a delay so it looks like it's loading something
    await Future<void>.delayed(const Duration(seconds: 1));
    _spaceship = await _session.spaceship;
    if (_spaceship == null) {
      state.value = ControllerState.error('Invalid spaceship'.localized);
    } else {
      await _refreshComponents();
    }
    if (state.value is! ControllerErrored) {
      state.value = ControllerState.idle();
    }
  }

  Future<void> _refreshComponents() async {
    final spacehipId = _id;
    if (spacehipId == null) {
      state.value = ControllerState.error(
        "You're not authorized to view this spaceship".localized,
      );
    } else {
      final result = await _spaceshipRepository.getSpaceshipComponents(
        spaceshipId: spacehipId,
      );
      result.when(
        (final success) {
          _components = success;
        },
        (final error) {
          state.value = ControllerState.error(
            error.message,
          );
        },
      );
    }
  }
}
