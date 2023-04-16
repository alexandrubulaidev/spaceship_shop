import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    super.key,
  });

  final IconData icon;
  final void Function() onTap;
  final double size;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        padding: EdgeInsets.all(size / 4),
        child: Center(
          child: FaIcon(
            icon,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}
