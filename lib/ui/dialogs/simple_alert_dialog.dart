import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../widgets/custom_switch.dart';
import '../widgets/simple_toggle_button.dart';

class MultiSelectorItem {
  MultiSelectorItem({
    required this.title,
    this.selected = false,
    this.onTap,
  });

  String title;
  bool selected = false;
  ValueChanged<bool>? onTap;
}

class SwitchItem {
  SwitchItem({
    required this.message,
    required this.selected,
    this.onSwitch,
  });

  String message;
  bool selected;
  void Function(bool value)? onSwitch;
}

class SimpleAction {
  SimpleAction({
    required this.text,
    this.color,
    this.onTap,
    this.onTapData,
  });

  String text;
  Color? color;
  void Function()? onTap;
  void Function(List<String> inputData, List<bool> switchData)? onTapData;
}

class SimpleAlertDialog extends StatefulWidget {
  const SimpleAlertDialog({
    super.key,
    this.actions = const [],
    this.title,
    this.message,
    this.inputs,
    this.selectors,
    this.body,
    this.switches,
    this.autoDismiss = true,
  });

  final List<SimpleAction> actions;
  final String? title;
  final String? message;
  final List<String>? inputs;
  final List<MultiSelectorItem>? selectors;
  final List<SwitchItem>? switches;
  final Widget? body;
  final bool autoDismiss;

  @override
  State<SimpleAlertDialog> createState() => _SimpleAlertDialogState();
}

class _SimpleAlertDialogState extends State<SimpleAlertDialog> {
  List<TextEditingController> inputControllers = [];

  @override
  void initState() {
    if (widget.inputs != null) {
      inputControllers = [];
      for (final _ in widget.inputs!) {
        inputControllers.add(TextEditingController());
      }
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final actionsWidgets = [
      for (int index = 0; index < widget.actions.length; index++) ...[
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.autoDismiss) {
                Navigator.of(context).pop();
              }
              widget.actions[index].onTap?.call();
              widget.actions[index].onTapData?.call(
                inputControllers.map((final e) => e.text).toList(),
                widget.switches?.map((final e) => e.selected).toList() ?? [],
              );
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.actions[index].color ??
                    Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 8,
                    right: 8,
                  ),
                  child: Text(
                    widget.actions[index].text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: Theme.of(context).dialogBackgroundColor,
                          fontWeightDelta: 2,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (index != widget.actions.length - 1)
          const SizedBox(
            width: 20,
            height: 10,
          )
      ]
    ];

    return AdaptiveDialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            if (widget.message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.message!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                ),
              ),
            if (widget.inputs != null)
              for (var input in widget.inputs!) ...[
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: inputControllers[widget.inputs!.indexOf(input)],
                    // autofocus: false,
                    onChanged: (final value) {},
                    decoration: InputDecoration(
                      isDense: true,
                      alignLabelWithHint: true,
                      labelText: input,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(10),
                      labelStyle: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .fontSize, //I believe the size difference here is 6.0 to account padding
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            if (widget.body != null) widget.body!,
            if (widget.switches != null)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var item in widget.switches!)
                      Row(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              item.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(fontSizeDelta: 1),
                            ),
                          ),
                          CustomSwitch(
                            value: item.selected,
                            onChange: (final value) {
                              item.onSwitch?.call(value);
                              setState(() {
                                item.selected = value;
                              });
                            },
                          ),
                        ],
                      )
                  ],
                ),
              ),
            if (widget.selectors != null)
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (var selector in widget.selectors!)
                    SimpleToggleButton(
                      isSelected: selector.selected,
                      text: selector.title,
                      onChanged: (final value) {
                        setState(() {
                          selector.selected = value;
                        });
                        selector.onTap!(value);
                      },
                    ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(
                right: 5,
                left: 5,
                top: 10,
              ),
              child: widget.actions.length > 2
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: actionsWidgets,
                    )
                  : IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: actionsWidgets,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: isSmallScreen(context) ? double.infinity : 300,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
