import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

Widget tiles(int index) {
  final Icon _starIcon = Icon(
    Icons.star,
    color: Colors.amber,
  );
  final Icon _assignIcon = Icon(
    Icons.assignment,
    color: Colors.white,
  );

  final assignBox = Hive.box("assignBox");
  final subjBox = Hive.box("subjBox");

  Color _color = Color(0xff303030);
  int _colorInt = 255;

  for (int i = 0; i < subjBox.length; i++) {
    if (assignBox.getAt(index).subject.compareTo(subjBox.getAt(i).title) == 0) {
      _colorInt = subjBox.getAt(i).color;
      _color = Color(_colorInt);
    }
  }

  return Card(
    color: _color,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 10),
              assignBox.getAt(index).isStar ? _starIcon : _assignIcon,
              Container(width: 10),
              Expanded(
                child: Text(
                  assignBox.getAt(index).title,
                  style: Get.context!.textTheme.headline6,
                ),
              ),
              Container(width: 10),
            ],
          ),
          Container(
            height: 5,
          ),
          Row(
            children: [
              Container(width: 45),
              Text(
                assignBox.getAt(index).date,
                style: Get.context!.textTheme.bodyText1,
              ),
              Text(" || ${assignBox.getAt(index).subject}")
            ],
          ),
          Container(
            height: 5,
          ),
          Row(
            children: [
              Container(width: 45),
              Expanded(child: Text(assignBox.getAt(index).desc)),
            ],
          ),
        ],
      ),
    ),
  );
}
