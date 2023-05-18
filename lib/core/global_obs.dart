import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';

// ignore: prefer-match-file-name, TODO: fix.
class BaseState<T> {
  BaseState([final T? initialValue]) {
    _time = DateTime.now().millisecondsSinceEpoch;
    _subject.add(initialValue);
  }

  final _subject = BehaviorSubject<T?>();
  int _time = DateTime.now().millisecondsSinceEpoch;
  int get time => _time;

  T? get value => _subject.value;
  set value(final T? val) {
    _time = DateTime.now().millisecondsSinceEpoch;
    _subject.add(val);
  }

  void setValue(final T? value, [final int? time]) {
    if (time != null) {
      _time = time;
    }
    this.value = value;
  }

  StreamSubscription<T?> listen(
    final void Function(T? event)? onData, {
    final Function? onError,
    final void Function()? onDone,
    final bool? cancelOnError,
  }) {
    return _subject.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

extension GlobalState on BaseState<dynamic> {
  static final _container = <String, BaseState<dynamic>>{};

  static BaseState<T> find<T>(final String key, [final T? value]) {
    if (_container[key] == null) {
      _container[key] = BaseState<T>(value);
    }

    return _container[key]! as BaseState<T>;
  }
}

extension RxBoolToggle on BaseState<dynamic> {
  void toggle() {
    if (value is Bool) {
      value = !(value as bool);
    }
  }
}
