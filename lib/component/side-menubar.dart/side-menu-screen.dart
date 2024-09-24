import 'dart:io';

import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../app/main-screen.dart';

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

  Text? getTextWidget(String txt, BoxConstraints constraint) {
    return constraint.maxWidth > 150 ? Text(txt) : null;
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ColoredBox(
        color: Colors.black87,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(MainPageScreen.routeName));
                },
                child: Card(
                    child: ListTile(
                  leading: const Icon(Icons.home),
                  title: getTextWidget('Main Menu', constraint),
                )),
              ),
            ),
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemBuilder: (ctx, ind) => GestureDetector(
                  onTap: () {
                    widget.controller.jumpToPage(ind);
                  },
                  child: Card(
                      child: ListTile(
                    textColor: selectedIndex == ind ? Colors.purple : null,
                    iconColor: selectedIndex == ind ? Colors.purple : null,
                    leading: Icon(widget.items[ind].icon),
                    title: getTextWidget(widget.items[ind].name, constraint),
                  )),
                ),
                itemCount: widget.items.length,
              ),
            ),
          ],
        ),
      );
    });
  }
}
