import 'package:flutter/material.dart';
import '../../../Models/MainItems.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});
  final listItem = mainItem;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(elevation: 3,
    
        destinations: [
          ...listItem.map((x) {
            return NavigationRailDestination(
              icon: Icon(x.icon),
              label: Text(x.name),
            );
          })
        ],
        selectedIndex: null,
        onDestinationSelected: (selected) =>
            Navigator.of(context).pushNamed(listItem[selected].route));
  }
}
