import 'package:assigngo/assignments/assignmentActions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget delete(int index) {
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
                AssignmentActions().delete(index);
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
