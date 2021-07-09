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
  final subjBox = Hive.box('subjBox');

  // Controls radius of borders for the panel when shown
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.home,
          size: 30,
          color: Colors.purple,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar(
                "Future update 😉",
                "Coming soon...",
                snackPosition: SnackPosition.BOTTOM,
                borderRadius: 30,
                barBlur: 20,
              );
            },
            icon: Icon(Icons.subject),
          ),
          IconButton(
            onPressed: () {
              Get.snackbar(
                "Future update 😉",
                "Coming soon...",
                barBlur: 20,
                snackPosition: SnackPosition.BOTTOM,
                borderRadius: 30,
              );
              // Get.to(() => ScheduleHome());
            },
            icon: Icon(Icons.calendar_today),
          ),
        ],
        title: Text("Assignments"),
      ),
      body: _listItem(),
    );
  }

  Widget _listItem() {
    return Sliding(
      isComp: false,
      isStar: false,
    );
  }
}
