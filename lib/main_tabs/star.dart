import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Star extends StatefulWidget {
  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> {
  final assignBox = Hive.box('assignBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.star,
          size: 30,
          color: Colors.amber,
        ),
        title: Text("Prioritized assignments"),
      ),
      body: _listItem(),
    );
  }

  Widget _listItem() {
    return Sliding(
      isComp: false,
      isStar: true,
    );
  }
}
