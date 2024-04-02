import 'package:better_assignments/alt_screens/settings/notification_service.dart';
import 'package:better_assignments/main_tabs/Drawer/drawer.dart';
import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Creates box to store the assignments & subjects
  final assignBox = Hive.box('assignBox');
  final _prefs = Hive.box("prefs");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: homeDrawer(),
      appBar: AppBar(
        leading: Icon(
          Icons.home,
          size: 30,
          color: Colors.purple,
        ),
        title: Text("Assignments"),
      ),
      body: _listItem(),
    );
  }

  Widget _listItem() {
    if (_prefs.get("firstLaunch", defaultValue: 0) == 0) {
      _prefs.put("firstLaunch", 1);
      check();
    }
    return Sliding(
      isComp: false,
      isStar: false,
    );
  }
}
