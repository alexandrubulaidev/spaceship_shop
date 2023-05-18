import 'package:flutter/material.dart';

class SegmentControl extends StatefulWidget {
  const SegmentControl({
    required this.tabs,
    required this.selected,
    this.height = 40,
    this.defaultIndex = 0,
    this.width = double.infinity,
    this.normalBackgroundColor = Colors.white,
    this.activeBackgroundColor = Colors.blue,
    this.normalTitleColor = Colors.blue,
    this.activeTitleColor = Colors.white,
    this.normalTitleStyle = const TextStyle(fontSize: 16, color: Colors.blue),
    this.activeTitleStyle = const TextStyle(fontSize: 18, color: Colors.white),
    this.radius = 0,
    this.borderColor = Colors.blue,
    this.selectNone = false,
  });
  final double height;
  final double width;
  final int defaultIndex;
  final List<String> tabs;
  final ValueChanged<int> selected;
  final Color normalBackgroundColor;
  final Color activeBackgroundColor;
  final Color normalTitleColor;
  final Color activeTitleColor;
  final TextStyle normalTitleStyle;
  final TextStyle activeTitleStyle;
  final Color borderColor;
  final double radius;
  final bool selectNone;

  @override
  State<SegmentControl> createState() => _SegmentControlState();
}

class _SegmentControlState extends State<SegmentControl>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: widget.borderColor,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius - 1),
          child: Row(
            children: <Widget>[
              for (var tabname in widget.tabs) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = widget.tabs.indexOf(tabname);
                        widget.selected(_selectedIndex);
                      });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:
                            (widget.tabs.indexOf(tabname) == _selectedIndex &&
                                    !widget.selectNone)
                                ? widget.activeBackgroundColor
                                : widget.normalBackgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          tabname,
                          style:
                              (widget.tabs.indexOf(tabname) == _selectedIndex &&
                                      !widget.selectNone)
                                  ? widget.activeTitleStyle
                                      .apply(color: widget.activeTitleColor)
                                  : widget.normalTitleStyle
                                      .apply(color: widget.normalTitleColor),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.tabs.indexOf(tabname) != widget.tabs.length - 1)
                  Container(
                    width: 1,
                    height: double.infinity,
                    decoration:
                        BoxDecoration(color: widget.activeBackgroundColor),
                  )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
