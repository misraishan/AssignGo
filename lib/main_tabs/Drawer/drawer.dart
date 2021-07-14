import 'package:better_assignments/alt_screens/settings/settings.dart';
import 'package:better_assignments/main_tabs/completed.dart';
import 'package:better_assignments/main_tabs/home.dart';
import 'package:better_assignments/main_tabs/star.dart';
import 'package:better_assignments/main_tabs/tabview.dart';
import 'package:better_assignments/slidable_widgets/assign_widgets.dart';
import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

final subjBox = Hive.box("subjBox");
Widget homeDrawer() {
  return Drawer(
    elevation: 30,
    child: ListView(
      children: [
        Container(height: 20),
        CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 60,
        ),
        TextButton(onPressed: () {}, child: Text("Sign in/Sign Up")),
        Container(height: 10),
        Divider(thickness: 5),
        Get.context!.isPhone ? SizedBox.shrink() : _tabs(),
        ListTile(
          leading: Icon(Icons.today_outlined),
          title: Text("Schedule"),
        ),
        Container(height: 10),
        Divider(thickness: 5),
        ListView.builder(
          itemCount: subjBox.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, index) {
            return Container(
              height: 75,
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => _Sorted(
                      title: subjBox.getAt(index).title,
                      index: index,
                    ),
                  );
                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(subjBox.getAt(index).title)],
                  ),
                  color: Color(subjBox.getAt(index).color),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

class _Sorted extends StatefulWidget {
  final String title;
  final int index;
  _Sorted({required this.title, required this.index});

  @override
  __SortedState createState() => __SortedState();
}

class __SortedState extends State<_Sorted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Sliding(
        isComp: false,
        isStar: false,
        subjSelect: subjBox.getAt(widget.index).title,
      ),
    );
  }
}

Widget _tabs() {
  return GridView.count(
    primary: false,
    crossAxisCount: 2,
    padding: EdgeInsets.all(5),
    crossAxisSpacing: 5,
    mainAxisSpacing: 5,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    children: [
      InkWell(
        onTap: () => Get.to(
          () => Home(),
        ),
        child: Container(
          color: Colors.purple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home),
              Text("Home"),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () => Get.to(
          () => Star(),
        ),
        child: Container(
          color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star),
              Text("Prioritized"),
            ],
          ),
        ),
      ),
      /*
      ListTile(
        onTap: () => Get.to(
          () => Home(),
        ),
        leading: Icon(Icons.home),
        title: Text("Home"),
        tileColor: Colors.purple,
      ),
      ListTile(
        onTap: () => Get.to(
          () => Star(),
        ),
        leading: Icon(Icons.star),
        title: Text("Prioritized"),
        tileColor: Colors.amber,
      ),
      ListTile(
        onTap: () => assignModal(true, null),
        leading: Icon(Icons.add, color: Colors.black),
        title: Text(
          "New assignment",
          style: TextStyle(color: Colors.black),
        ),
        tileColor: Colors.white,
      ),
      ListTile(
        onTap: () => Get.to(
          () => Completed(),
        ),
        leading: Icon(Icons.check_box),
        title: Text("Completed"),
        tileColor: Colors.green,
      ),
      ListTile(
        onTap: () => Get.to(
          () => Settings(),
        ),
        leading: Icon(Icons.home),
        title: Text("Settings"),
        tileColor: Colors.blue,
      ),
      */
    ],
  );
}
