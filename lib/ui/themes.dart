import 'package:flutter/material.dart';

final kTheme = ThemeData(
  primaryColorDark: Colors.green[900],
  primaryColor: Colors.green[600],
  primaryColorLight: Colors.green[200],
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
  dialogBackgroundColor: Colors.white,
  disabledColor: Colors.black38,
  brightness: Brightness.light,
  textTheme: ThemeData(brightness: Brightness.light).textTheme.apply(
        bodyColor: Colors.grey[800],
      ),
  colorScheme: ColorScheme(
    primary: Colors.green[600]!,
    // primaryVariant: Colors.green[900]!,
    secondary: Colors.green[600]!,
    // secondaryVariant: Colors.green[900]!,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.grey[800]!,
    onBackground: Colors.grey[800]!,
    onError: Colors.white,
    brightness: Brightness.light,
  ).copyWith(background: Colors.grey[900]),
);
