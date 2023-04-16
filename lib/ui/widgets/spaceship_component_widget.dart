// ignore_for_file: use_named_constants

import 'package:flutter/material.dart';

import '../../model/spaceship_component.dart';
import '../../utils/app_localizations.dart';
import 'online_image.dart';

class SpaceshipComponentWidget extends StatelessWidget {
  const SpaceshipComponentWidget({
    required this.component,
    this.padding,
    this.price,
    super.key,
  });

  final SpaceshipComponent component;
  final EdgeInsets? padding;
  final String? price;

  @override
  Widget build(final BuildContext context) {
    final title =
        '${component.type?.toUpperCase() ?? 'UNKNOWN MODEL'.localized}'
        '${component.model == null ? '' : ' - ${component.model?.toUpperCase()}'}';
    final subtitle = component.manufacturer ?? 'Unknown Manufacturer'.localized;
    final cost = price;
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 80,
            child: OnlineImage(
              placeholder: 'assets/gears.jpg',
              picture: component.picture,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (cost != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      cost,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.apply(fontWeightDelta: 3),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
