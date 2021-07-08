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

bool _isNew = true;
int? _index;
dynamic assignModal(bool isNew, int? index) {
  _isNew = isNew;
  if (isNew) {
    clearControllers();
  } else {
    clearControllers();
    _index = index;
    _title.text = assignBox.getAt(index!).title;
    _desc.text = assignBox.getAt(index).desc;
    _date.text = assignBox.getAt(index).date;
  }
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
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  // Title
                  Container(height: 20),
                  titleButton(),

                  // Description
                  Container(height: 20),
                  descriptionButton(),

                  // Due date selection
                  Container(height: 20),
                  dateTimePicker(),

                  // Subject selection
                  Container(height: 20),
                  DropDown(),

                  // Submit button selection
                  Container(height: 20),
                  returnButton(),

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

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final List<String> subjects = [];
  String _dropDownValue = "Choose a subject";

  @override
  void initState() {
    super.initState();
    if (subjBox.isNotEmpty) {
      subjects.clear();
      for (int i = 0; i < subjBox.length; i++) {
        subjects.add(subjBox.getAt(i).title);
      }
    }
    if (_isNew) {
      _dropDownValue = subjects.first;
      getSubj(_dropDownValue);
    } else {
      _dropDownValue = assignBox.getAt(_index!).subject;
      getSubj(_dropDownValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xff616161)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(
              Icons.subject,
              color: Colors.grey,
            ),
            Container(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down),
                  // isExpanded: true,
                  hint: Text("Create a subject first!"),
                  value: _dropDownValue,
                  items: subjects.map(
                    (String item) {
                      return new DropdownMenuItem<String>(
                        value: item,
                        child: new Text(item),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        _dropDownValue = newValue!;
                        getSubj(_dropDownValue);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String finalSubj = "";
void getSubj(String subject) {
  finalSubj = subject;
}

Widget returnButton() {
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
          if (_isNew) {
            assignBox.add(
              AssignModel(
                title: _title.text,
                date: _date.text,
                desc: _desc.text,
                notifIDLong: _idLong,
                notifIDShort: _idShort,
                subject: finalSubj,
              ),
            );
          } else {
            AwesomeNotifications()
                .cancel(assignBox.getAt(_index!).notifIDShort);
            AwesomeNotifications().cancel(assignBox.getAt(_index!).notifIDLong);
            assignBox.putAt(
              _index!,
              AssignModel(
                title: _title.text,
                date: _date.text,
                desc: _desc.text,
                notifIDLong: _idLong,
                notifIDShort: _idShort,
                subject: finalSubj,
              ),
            );
          }
          Get.back();
        }
      }
    },
    icon: _isNew ? Icon(Icons.add) : Icon(Icons.edit),
    label: _isNew ? Text("Add Assignment") : Text("Edit Assignment"),
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
