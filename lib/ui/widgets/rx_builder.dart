import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/app_localizations.dart';

/// Subscribes to the [subject] and invokes the builder on new values.
/// On error it will invoke the [error] builder instead if it's not null.
class RxBuilder<T> extends StatefulWidget {
  const RxBuilder({
    required this.subject,
    required this.builder,
    this.error,
    super.key,
  });

  final BehaviorSubject<T> subject;
  final Widget Function(BuildContext context, T? value) builder;
  final Widget Function(BuildContext context, Exception? value)? error;

  @override
  State<RxBuilder<T>> createState() => _RxBuilderState<T>();
}

class _RxBuilderState<T> extends State<RxBuilder<T>> {
  StreamSubscription<T>? _subscription;
  T? _value;
  Exception? _error;

  @override
  void initState() {
    super.initState();
    _value = widget.subject.value;
    _subscription = widget.subject.listen(
      (final value) {
        setState(() {
          _value = value;
        });
      },
      onError: (final error) {
        setState(() {
          _error = widget.subject.errorOrNull as Exception? ??
              Exception(
                'Unexpected Error'.localized,
              );
        });
      },
    );
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final errorBuilder = widget.error;
    if (_error == null || errorBuilder == null) {
      return widget.builder(context, _value);
    }
    return errorBuilder(context, _error);
  }
}
