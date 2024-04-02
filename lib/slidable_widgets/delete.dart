import 'package:awesome_notifications/awesome_notifications.dart';
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
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Container(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                AwesomeNotifications()
                    .cancel(assignBox.getAt(index).notifIDLong);
                AwesomeNotifications()
                    .cancel(assignBox.getAt(index).notifIDShort);
                assignBox.deleteAt(index);
                Get.back();
              },
              child: Text("Confirm"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          )
        ],
      ),
    ],
  );

  return alert;
}
