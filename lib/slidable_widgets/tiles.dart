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
  return Card(
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

/*
ListTile(
    leading: assignBox.getAt(index).isStar ? _starIcon : _assignIcon,
    isThreeLine: true,
    tileColor: Colors.black,
    title: Text("${assignBox.getAt(index).title}"),
    subtitle: Text(
        "${assignBox.getAt(index).date} \n ${assignBox.getAt(index).desc}"),
  );
  */
