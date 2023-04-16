import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BehaviorSubjectBuilder<T> extends StatefulWidget {
  const BehaviorSubjectBuilder({
    required this.subject,
    required this.builder,
    super.key,
  });

  final BehaviorSubject<T> subject;
  final Widget Function(BuildContext context, T? value) builder;

  @override
  State<BehaviorSubjectBuilder<T>> createState() =>
      _BehaviorSubjectBuilderState<T>();
}

class _BehaviorSubjectBuilderState<T> extends State<BehaviorSubjectBuilder<T>> {
  StreamSubscription<T>? _subscription;
  T? _value;

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
    );
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return widget.builder(context, _value);
  }
}
