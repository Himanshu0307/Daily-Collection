import 'package:flutter/material.dart';
import '../../Models/SideItem.dart';

class SideWidget extends StatefulWidget {
  final List<SideItem> items;
  final PageController controller;
  const SideWidget(this.items, this.controller, {super.key});

  @override
  State<SideWidget> createState() => _SideWidgetState();
}

class _SideWidgetState extends State<SideWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(changeSelectedIndex);
  }

  @override
  dispose() {
    widget.controller.removeListener(changeSelectedIndex);
    widget.controller.dispose();
    super.dispose();
  }

  changeSelectedIndex() => setState(() {
        selectedIndex = widget.controller.page?.toInt() ?? 0;
      });

  onNavigationSelector(int index, BuildContext context) {
    if (index == 0) {
      Navigator.of(context).pop();
    } else {
      widget.controller.jumpToPage(
        index - 1,
      );
    }
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        onDestinationSelected: (ind) => onNavigationSelector(ind, context),
        labelType: NavigationRailLabelType.selected,
        destinations: [
          const NavigationRailDestination(
              icon: Icon(Icons.home), label: Text("Main Menu")),
          ...widget.items.map((x) => NavigationRailDestination(
              icon: Icon(x.icon), label: Text(x.name)))
        ],
        selectedIndex: selectedIndex + 1);
  }
}
