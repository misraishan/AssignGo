import 'package:better_assignments/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

final subjBox = Hive.box("subjBox");
final _subjName = new TextEditingController();
final _profName = new TextEditingController();
final _profEmail = new TextEditingController();
Color _color = Colors.indigoAccent[200]!;
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
                        style: Theme.of(Get.context!).textTheme.titleLarge,
                      )
                    : Text(
                        "Edit subject",
                        style: Theme.of(Get.context!).textTheme.titleLarge,
                      ),
              ),

              Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
              // Subject name
              TextField(
                controller: _subjName,
                inputFormatters: [LengthLimitingTextInputFormatter(25)],
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
                inputFormatters: [LengthLimitingTextInputFormatter(35)],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.grade),
                  labelText: "Teacher name",
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),

              // Professor/teacher Email
              TextField(
                inputFormatters: [LengthLimitingTextInputFormatter(35)],
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
                        _resetVars();
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
                            _resetVars();
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
                            _resetVars();
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

void _resetVars() {
  _subjName.clear();
  _profName.clear();
  _profEmail.clear();
}

bool _checkParams() {
  String _checkTitle = _subjName.text.removeAllWhitespace;
  bool _isTrue = false;
  print(_checkTitle);
  if (_checkTitle.isNotEmpty) {
    _isTrue = true;
    if (_profEmail.text.isNotEmpty && _profEmail.text.isEmail) {
      _isTrue = true;
    } else if (_profEmail.text.isNotEmpty && !_profEmail.text.isEmail) {
      _isTrue = false;
      Get.snackbar(
        "Warning!",
        "Email can't be validated.",
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
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
