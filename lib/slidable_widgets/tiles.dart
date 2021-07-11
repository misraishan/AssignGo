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

  Color _color;
  Get.isDarkMode ? _color = Color(0xff303030) : _color = Color(0xffd6d6d6);
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
                child: SelectableText(
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
                style: Theme.of(Get.context!).textTheme.caption,
              ),
              assignBox.getAt(index).subject != ""
                  ? Text(
                      " || ${assignBox.getAt(index).subject}",
                      style: Theme.of(Get.context!).textTheme.caption,
                    )
                  : Container(),
            ],
          ),
          Container(
            height: 5,
          ),
          Row(
            children: [
              Container(width: 45),
              Expanded(
                child: SelectableText(
                  assignBox.getAt(index).desc,
                  style: Theme.of(Get.context!).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
