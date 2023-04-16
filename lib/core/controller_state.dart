import 'package:rxdart/rxdart.dart';

import '../utils/app_localizations.dart';

class ControllerState {
  ControllerState();

  factory ControllerState.idle() => ControllerIdle();
  factory ControllerState.loading() => ControllerLoading();
  factory ControllerState.uninitialized() => ControllerUninitialized();
  factory ControllerState.error(final dynamic value) =>
      ControllerErrored(value);
}

class ControllerErrored extends ControllerState {
  ControllerErrored(this.value) : super();
  final dynamic value;

  String get message {
    if (value is String) {
      return value as String;
    }

    return 'Unexpected Error'.localized;
  }
}

class ControllerIdle extends ControllerState {
  ControllerIdle() : super();
}

class ControllerLoading extends ControllerState {
  ControllerLoading() : super();
}

class ControllerUninitialized extends ControllerState {
  ControllerUninitialized() : super();
}

mixin ControllerStateMixin {
  BehaviorSubject<ControllerState> state =
      BehaviorSubject<ControllerState>.seeded(
    ControllerUninitialized(),
  );
}
