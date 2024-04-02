import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:assigngo/models/assignment.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';

final TextEditingController _title = TextEditingController();
final TextEditingController _desc = TextEditingController();
final TextEditingController _date = TextEditingController();
final assignBox = Hive.box('assignBox');
final subjBox = Hive.box("subjBox");
final prefs = Hive.box("prefs");

bool _isNew = true;
int? _index;
String _subject = "";

dynamic assignModal(bool isNew, int? index, String subject) {
  _isNew = isNew;
  _subject = subject;
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
    enableDrag: true,
    context: Get.context!,
    builder: (context) {
      return Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                  subjBox.isNotEmpty ? DropDown() : SizedBox.shrink(),

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
      prefixIcon: Icon(Icons.assignment),
      labelText: "Assignment Name",
    ),
  );
}

Widget dateTimePicker() {
  initializeDateFormatting("en_US");
  return DateTimePicker(
    type: DateTimePickerType.dateTime,
    use24HourFormat: false,
    controller: _date,
    dateHintText: "Due Date and Time",
    firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
    lastDate: DateTime(DateTime.now().year + 2),
    icon: Icon(Icons.cloud_circle),
    dateMask: "MMM d, yy - hh:mm a",
    decoration: InputDecoration(
      labelText: "Due Date and Time",
      prefixIcon: Icon(Icons.calendar_today),
    ),
    onChanged: (val) {
      _date.text = val;
    },
    locale: Localizations.localeOf(Get.context!),
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
  String? _dropDownValue = "Select a Subject";

  @override
  void initState() {
    super.initState();

    if (subjBox.isNotEmpty) {
      subjects.clear();
      subjects.add("Choose a subject");
      for (int i = 0; i < subjBox.length; i++) {
        subjects.add(subjBox.getAt(i).title);
      }
    }
    if (_isNew) {
      if (subjects.isEmpty) {
        _dropDownValue = null;
      } else {
        if (_subject != "") {
          _dropDownValue = _subject;
          getSubj(_dropDownValue!);
        } else {
          _dropDownValue = subjects.first;
          getSubj(_dropDownValue!);
        }
      }
    } else {
      if (subjBox.isNotEmpty) {
        if (assignBox.getAt(_index!).subject == "") {
          _dropDownValue = subjects.first;
          getSubj(_dropDownValue!);
        } else {
          _dropDownValue = assignBox.getAt(_index!).subject;
          getSubj(_dropDownValue!);
        }
      }
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
                        getSubj(_dropDownValue!);
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

String? finalSubj = "";
void getSubj(String subject) {
  if (subject.compareTo("Choose a subject") == 0) {
    subject = "";
  }
  finalSubj = subject;
}

Widget returnButton() {
  return ElevatedButton.icon(
    onPressed: () {
      if (_date.text == "") {
        Get.snackbar(
          "Warning!",
          "Due Date is required.",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        if (_title.text.isEmpty) {
          Get.snackbar(
            "Warning!",
            "Assignment Name is required.",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          if (_isNew) {
            int _idLong = prefs.get("notifID", defaultValue: 0);
            int _idShort = _idLong + 1;
            int _idStar = _idLong + 2;
            prefs.put("notifID", _idLong + 3);
            DateTime _dateDue = DateTime.parse(_date.text);
            createNotificationSchedule(_dateDue, _idLong, _idShort, _idStar);
            assignBox.add(
              Assignment(
                title: _title.text,
                date: _date.text,
                desc: _desc.text,
                notifIDLong: _idLong,
                notifIDShort: _idShort,
                notifIDStar: _idStar,
                subject: finalSubj!,
              ),
            );
          } else {
            AwesomeNotifications()
                .cancel(assignBox.getAt(_index!).notifIDShort);
            AwesomeNotifications().cancel(assignBox.getAt(_index!).notifIDLong);
            if (assignBox.getAt(_index!).isStar) {
              AwesomeNotifications()
                  .cancel(assignBox.getAt(_index!).notifIDStar);
            }

            int _idLong = assignBox.getAt(_index!).notifIDLong;
            int _idShort = assignBox.getAt(_index!).notifIDShort;
            int _idStar = assignBox.getAt(_index!).notifIDStar;
            DateTime _dateDue = DateTime.parse(_date.text);
            createNotificationSchedule(_dateDue, _idLong, _idShort, _idStar);

            assignBox.putAt(
              _index!,
              Assignment(
                title: _title.text,
                date: _date.text,
                desc: _desc.text,
                notifIDLong: _idLong,
                notifIDShort: _idShort,
                notifIDStar: _idStar,
                subject: finalSubj!,
                isComplete: assignBox.getAt(_index!).isComplete,
                isStar: assignBox.getAt(_index!).isStar,
              ),
            );
          }
          Get.back();
        }
      }
    },
    icon: _isNew ? Icon(Icons.add) : Icon(Icons.edit),
    label: _isNew ? Text("Add Assignment") : Text("Save Assignment"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
    ),
  );
}

void createNotificationSchedule(
    DateTime _dateDue, int _idLong, int _idShort, int _idStar) {
  final DateTime _longDur = _dateDue.subtract(Duration(hours: 24));
  final DateTime _shortDur = _dateDue.subtract(Duration(hours: 12));
  final DateTime _starDur = _dateDue.subtract(Duration(hours: 48));

  if (!_isNew && assignBox.getAt(_index!).isStar) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _idStar,
        channelKey: 'star',
        title: _title.text,
        body: _desc.text,
        displayOnBackground: true,
      ),
      schedule: NotificationCalendar(
        allowWhileIdle: true,
        year: _starDur.year,
        month: _starDur.month,
        hour: _starDur.hour,
        minute: _starDur.minute,
        day: _starDur.day,
      ),
    );
  }

// Long notification refers to 24 hrs before deadline, short to 12 hrs
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: _idLong,
      channelKey: 'long',
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
      channelKey: 'short',
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
