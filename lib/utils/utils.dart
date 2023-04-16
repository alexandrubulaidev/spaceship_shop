import 'package:flutter/material.dart';

bool isSmallScreen(final BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return screenSize.shortestSide < 600;
}

bool isPortrait(final BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return screenSize.width < screenSize.height;
}
