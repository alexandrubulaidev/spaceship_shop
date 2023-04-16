import 'package:flutter/material.dart';

import '../../model/spaceship.dart';
import '../../utils/app_localizations.dart';
import 'online_image.dart';

class SpaceshipDetailsWidget extends StatelessWidget {
  const SpaceshipDetailsWidget({
    required this.spaceship,
  });

  final Spaceship? spaceship;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 300,
          ),
          child: OnlineImage(
            placeholder: 'assets/spaceship.jpg',
            picture: spaceship?.picture,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          spaceship?.name ?? 'UNNAMED'.localized,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '${'Model'.localized}: ${spaceship?.model ?? 'N/A'.localized}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
