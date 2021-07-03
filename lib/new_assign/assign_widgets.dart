import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:nanoid/nanoid.dart';

final TextEditingController _title = TextEditingController();
final TextEditingController _desc = TextEditingController();
final TextEditingController _date = TextEditingController();
final assignBox = Hive.box('assignBox');
final subjBox = Hive.box("subjBox");

void clearControllers() {
  _title.clear();
  _desc.clear();
  _date.clear();
}

Widget titleButton() {
  return TextField(
    controller: _title,
    decoration: InputDecoration(
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      prefixIcon: Icon(Icons.assignment),
      labelText: "Assignment name",
    ),
  );
}

Widget dateTimePicker() {
  return DateTimePicker(
    type: DateTimePickerType.dateTime,
    dateMask: 'dd / MM / yy - hh : mm',
    use24HourFormat: false,
    controller: _date,
    firstDate: DateTime(2020),
    lastDate: DateTime(2025),
    icon: Icon(Icons.cloud_circle),
    decoration: InputDecoration(
      labelText: "Due Date & time",
      prefixIcon: Icon(Icons.calendar_today),
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onChanged: (val) {
      _date.text = val;
    },
  );
}

Widget descriptionButton() {
  return TextField(
    controller: _desc,
    autocorrect: true,
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    textInputAction: TextInputAction.newline,
    decoration: InputDecoration(
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      prefixIcon: Icon(Icons.assignment),
      labelText: "Description",
    ),
  );
}

Widget returnButton(String subject) {
  return ElevatedButton.icon(
    onPressed: () {
      if (_date.text == "") {
        Get.snackbar(
          "Warning!",
          "Date can't be empty.",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Generates a new number 9 digits long.
        // Converts _date.text to DateTime to use for schedule notifications
        int _idLong = int.parse(customAlphabet('1234567890', 9));
        int _idShort = int.parse(customAlphabet('1234567890', 9));
        DateTime _dateDue = DateTime.parse(_date.text);

        notifID(_dateDue, _idLong, _idShort);

        if (_title.text.isEmpty) {
          Get.snackbar(
            "Warning!",
            "Title can't be empty.",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          assignBox.add(
            AssignModel(
              title: _title.text,
              date: _date.text,
              desc: _desc.text,
              notifIDLong: _idLong,
              notifIDShort: _idShort,
              subject: subject,
            ),
          );
          Get.back();
        }
      }
    },
    icon: Icon(Icons.add),
    label: Text("Add assignment"),
    style: ElevatedButton.styleFrom(
      primary: Colors.green,
    ),
  );
}

void notifID(DateTime _dateDue, int _idLong, int _idShort) {
  final DateTime _longDur = _dateDue.subtract(Duration(hours: 24));
  final DateTime _shortDur = _dateDue.subtract(Duration(hours: 6));
  // Create first notification (12 hrs from deadline)
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: _idLong,
      channelKey: '24hr',
      title: _title.text,
      body: _desc.text,
      displayOnBackground: true,
    ),
    schedule: NotificationCalendar(
      allowWhileIdle: true,
      year: _longDur.year,
      month: _longDur.month,
      hour: _longDur.hour,
      minute: _longDur.minute,
      day: _longDur.day,
    ),
  );

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: _idShort,
      channelKey: '24hr',
      title: _title.text,
      body: _desc.text,
      displayOnBackground: true,
    ),
    schedule: NotificationCalendar(
      allowWhileIdle: true,
      year: _shortDur.year,
      month: _shortDur.month,
      hour: _shortDur.hour,
      minute: _shortDur.minute,
      day: _shortDur.day,
    ),
  );
}
