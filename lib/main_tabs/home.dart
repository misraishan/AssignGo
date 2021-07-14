import 'package:better_assignments/main_tabs/Drawer/drawer.dart';
import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Creates box to store the assignments & subjects
  final assignBox = Hive.box('assignBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: context.isPhone ? homeDrawer() : null,
      appBar: AppBar(
        leading: Icon(
          Icons.home,
          size: 30,
          color: Colors.purple,
        ),
        title: Text("Assignments"),
      ),
      body: context.isPhone
          ? _listItem()
          : Row(
              children: [homeDrawer(), Expanded(child: _listItem())],
            ),
    );
  }

  Widget _listItem() {
    return Sliding(
      isComp: false,
      isStar: false,
    );
  }
}
