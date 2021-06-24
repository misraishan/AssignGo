import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

Widget delete(int index) {
  final assignBox = Hive.box('assignBox');
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    title: Text(
      "Are you sure you want to delete this assignment?",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Cancel"),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          primary: Colors.red,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          assignBox.deleteAt(index);
          Get.back();
        },
        child: Text("Confirm"),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          primary: Colors.green,
        ),
      )
    ],
  );

  return alert;
}
