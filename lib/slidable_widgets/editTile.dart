import 'package:better_assignments/new_assign/assign_widgets.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:nanoid/nanoid.dart';

// ignore: must_be_immutable

dynamic editTile(index) {
  final assignBox = Hive.box('assignBox');
  print(index);
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _date = TextEditingController();

  _title.text = assignBox.getAt(index).title;
  _desc.text = assignBox.getAt(index).desc;
  _date.text = assignBox.getAt(index).date;
  int _idShort = assignBox.getAt(index).notifIDShort,
      _idLong = assignBox.getAt(index).notifIDLong;

  final result = showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    context: Get.context!,
    builder: (context) {
      return Container(
        decoration: new BoxDecoration(
          color: Colors.black,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.only(bottom: 0),
              child: Column(
                children: [
                  // Title
                  Container(height: 20),
                  TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(Icons.assignment),
                      labelText: "Assignment name",
                    ),
                  ),

                  // Description
                  Container(height: 20),
                  TextField(
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
                  ),

                  // Due date selection
                  Container(height: 20),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    dateMask: 'dd / MM / yy - hh:mm',
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
                      _idLong = int.parse(customAlphabet('1234567890', 9));
                      _idShort = int.parse(customAlphabet('1234567890', 9));
                      DateTime _dateDue = DateTime.parse(_date.text);

                      notifID(_dateDue, _idLong, _idShort);
                    },
                  ),

                  // Submit button selection
                  Container(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_title.text.isEmpty) {
                        Get.snackbar(
                          "Warning!",
                          "Title can't be empty.",
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        assignBox.getAt(index).title = _title.text;
                        assignBox.getAt(index).desc = _desc.text;
                        assignBox.getAt(index).date = _date.text;
                        assignBox.getAt(index).notifIDShort = _idShort;
                        assignBox.getAt(index).notifIDLong = _idLong;
                        Get.back();
                      }
                    },
                    icon: Icon(Icons.done),
                    label: Text("Edit Assignment"),
                  ),
                  Container(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return result;
}
