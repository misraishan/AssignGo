import 'package:better_assignments/models/subject.dart';
import 'package:flutter/material.dart';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

final subjBox = Hive.box("subjBox");
final _subjName = new TextEditingController();
final _profName = new TextEditingController();
final _profEmail = new TextEditingController();
var _color = Color(0xffAB47BC);
bool _isNew = true;
int? _index;
Widget newSubj(bool isNew, int? index) {
  if (!isNew) {
    _isNew = isNew;
    _index = index;
    _profEmail.text = subjBox.getAt(index!).email;
    _subjName.text = subjBox.getAt(index).title;
    _profName.text = subjBox.getAt(index).name;
    _color = Color(subjBox.getAt(index).color);
  } else {
    _isNew = isNew;
  }
  return Container(
    padding: EdgeInsets.all(10),
    child: Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: isNew
                    ? Text(
                        "Create a new subject",
                        style: Theme.of(Get.context!).textTheme.headline6,
                      )
                    : Text(
                        "Edit subject",
                        style: Theme.of(Get.context!).textTheme.headline6,
                      ),
              ),

              Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
              // Subject name
              TextField(
                controller: _subjName,
                maxLength: 25,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.subject),
                  labelText: "Subject Name",
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),

              // Professor/teacher name
              TextField(
                controller: _profName,
                maxLength: 35,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.grade),
                  labelText: "Teacher name",
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),

              // Professor/teacher Email
              TextField(
                maxLength: 35,
                controller: _profEmail,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Teacher email",
                ),
              ),

              // Color picker
              Center(
                child: ColorPicker(
                  color: _color,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.accent: true,
                    ColorPickerType.primary: false,
                    ColorPickerType.wheel: true,
                  },
                  onColorChanged: (Color color) => _color = color,
                ),
              ),

              // Submit & Cancels
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _subjName.clear();
                        _profName.clear();
                        _profEmail.clear();
                        _color = Color(0xffAB47BC);
                        Get.back();
                      },
                      child: Text("Cancel"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        int _colorInt = _color.value;
                        if (_checkParams() == !true) {
                          print("Test");
                        } else {
                          if (_isNew) {
                            subjBox.add(
                              Subject(
                                title: _subjName.text,
                                name: _profName.text,
                                color: _colorInt,
                                email: _profEmail.text,
                              ),
                            );
                            _subjName.clear();
                            _profName.clear();
                            _profEmail.clear();

                            _color = Color(0xffAB47BC);
                          } else if (!_isNew) {
                            subjBox.putAt(
                              _index!,
                              Subject(
                                email: _profEmail.text,
                                title: _subjName.text,
                                name: _profName.text,
                                color: _colorInt,
                              ),
                            );
                            _subjName.clear();
                            _profName.clear();
                            _profEmail.clear();
                            _color = Color(0xffAB47BC);
                          }
                          Get.back();
                        }
                      },
                      child: isNew ? Text("Create") : Text("Update"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

dynamic _checkParams() async {
  String _checkTitle = _subjName.text.removeAllWhitespace;
  bool _isTrue = false;
  print(_checkTitle);
  if (_checkTitle.isNotEmpty) {
    _isTrue = true;
    if (_profEmail.text.isNotEmpty && _profEmail.text.isEmail) {
      _isTrue = true;
    } else if (!_profEmail.text.isEmail) {
      _isTrue = false;
    }
  } else {
    Get.snackbar(
      "Warning!",
      "Title can't be empty.",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  print(_isTrue);
  return _isTrue;
}
