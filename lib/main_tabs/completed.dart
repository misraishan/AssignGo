import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  final assignBox = Hive.box('assignBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.check_box,
          size: 30,
          color: Colors.green,
        ),
        title: Text("Completed assignments"),
      ),
      body: _listItem(),
    );
  }

  Widget _listItem() {
    return Sliding(
      isComp: true,
      isStar: false,
    );
  }
}
