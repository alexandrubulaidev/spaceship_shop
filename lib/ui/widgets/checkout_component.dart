import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/spaceship_shop_component.dart';
import 'rounded_icon_button.dart';

class CheckoutComponent extends StatefulWidget {
  const CheckoutComponent({
    required this.component,
    required this.items,
    required this.onChange,
    super.key,
  });

  final SpaceshipShopComponent component;
  final int items;
  final void Function(int count) onChange;

  @override
  State<CheckoutComponent> createState() => _CheckoutComponentState();
}

class _CheckoutComponentState extends State<CheckoutComponent> {
  int _items = 0;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  @override
  Widget build(final BuildContext context) {
    final title = '${widget.component.type.toUpperCase()}'
        ' - ${widget.component.model.toUpperCase()}';
    final subtitle = widget.component.manufacturer;
    final cost = '${widget.component.price.toStringAsFixed(0)}\$';

    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              const SizedBox(height: 5),
              Text(
                cost,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.apply(fontWeightDelta: 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Row(
          children: [
            RoundedIconButton(
              size: 30,
              icon: FontAwesomeIcons.minus,
              onTap: () {
                setState(() {
                  _items--;
                  if (_items < 0) {
                    _items = 0;
                  }
                });
                widget.onChange(_items);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '$_items',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RoundedIconButton(
              size: 30,
              icon: FontAwesomeIcons.plus,
              onTap: () {
                setState(() {
                  _items++;
                });
                widget.onChange(_items);
              },
            ),
          ],
        )
      ],
    );
  }
}
