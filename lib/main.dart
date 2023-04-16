import 'package:flutter/material.dart';
import 'application.dart';
import 'router.dart';
import 'ui/themes.dart';

void main() async {
  // Practically we'll want to create a loader screen and await for this to complete.
  // A problem for another time.
  await Application.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      title: 'Spaceship Stats',
      theme: kTheme,
      routerConfig: router,
    );
  }
}
