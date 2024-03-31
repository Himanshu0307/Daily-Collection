import 'package:flutter/material.dart';

import '../../Models/MainItems.dart';

class ListItemWidget extends StatelessWidget {
  final MainItems item;
  const ListItemWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(item.route);
      },
      child: Row(
        children: [
          Icon(
            item.icon,
            grade: 3,
            size: 100,
            color: Colors.blueGrey,
          ),
          Text(item.name),
        ],
        // subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      ),
    );
  }
}
