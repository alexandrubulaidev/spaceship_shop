import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/app_localizations.dart';
import 'simple_alert_dialog.dart';

Future<void> showSimpleAlertDialog({
  required final BuildContext context,
  required final SimpleAlertDialog dialog,
}) async {
  await showDialog<void>(
    context: context,
    builder: (final context) {
      return dialog;
    },
  );
}

Future<void> showFailureDialog({
  required final BuildContext context,
  required final String message,
}) async {
  final completer = Completer<void>();
  await showSimpleAlertDialog(
    context: context,
    dialog: SimpleAlertDialog(
      title: 'Failed'.localized,
      message: message,
      actions: [
        SimpleAction(
          text: 'OK'.localized,
          onTap: completer.complete,
        ),
      ],
    ),
  );
  return completer.future;
}
