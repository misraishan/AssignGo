import 'package:better_assignments/main_tabs/tabview.dart';
import 'package:better_assignments/slidable_widgets/assign_widgets.dart';
import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final subjBox = Hive.box("subjBox");
Widget homeDrawer() {
  return Drawer(
    elevation: 30,
    child: ListView(
      children: [
        Container(height: 10),
        Center(
          child: Text(
            "Sort by Subjects",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
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
    final _email = subjBox.getAt(widget.index).email;
    final _name = subjBox.getAt(widget.index).name;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => TabView());
          },
        ),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          _name != ""
              ? Text(subjBox.getAt(widget.index).name)
              : SizedBox.shrink(),
          _email != ""
              ? InkWell(
                  child: Text(
                    _email,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: assignBox.getAt(widget.index).email,
                    );
                    launch(
                      _emailLaunchUri.toString(),
                    );
                  })
              : SizedBox.shrink(),
          Sliding(
            isComp: false,
            isStar: false,
            subjSelect: subjBox.getAt(widget.index).title,
          ),
        ],
      ),
    );
  }
}
