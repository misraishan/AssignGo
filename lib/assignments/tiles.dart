import 'package:date_format/date_format.dart';
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
  );

  final assignBox = Hive.box("assignBox");
  final subjBox = Hive.box("subjBox");

  Color _color;
  Get.isDarkMode ? _color = Color(0xff303030) : _color = Colors.white;
  int _colorInt = 255;

  for (int i = 0; i < subjBox.length; i++) {
    if (assignBox.getAt(index).subject.compareTo(subjBox.getAt(i).title) == 0) {
      _colorInt = subjBox.getAt(i).color;
      _color = Color(_colorInt);
    }
  }

  String _dateFormatted = formatDate(
      DateTime.parse(assignBox.getAt(index).date),
      [M, ' ', d, ', ', yy, ' — ', hh, ':', nn, ' ', am]);

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
                  style: Get.context!.textTheme.titleLarge,
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
                _dateFormatted,
                // assignBox.getAt(index).date,
                style: Theme.of(Get.context!).textTheme.bodySmall,
              ),
              assignBox.getAt(index).subject != ""
                  ? Text(
                      " || ${assignBox.getAt(index).subject}",
                      style: Theme.of(Get.context!).textTheme.bodySmall,
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
                  style: Theme.of(Get.context!).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
