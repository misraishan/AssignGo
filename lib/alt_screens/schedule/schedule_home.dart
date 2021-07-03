import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ScheduleHome extends StatefulWidget {
  @override
  _ScheduleHomeState createState() => _ScheduleHomeState();
}

class _ScheduleHomeState extends State<ScheduleHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calendar_today),
            Container(width: 5),
            Text("Schedule"),
          ],
        ),
      ),
      body: _newBody(),
    );
  }

  Widget _newBody() {
    File? imageFile;
    if (imageFile == null) {
      return Center(
        child: InkWell(
          child: CircleAvatar(
            maxRadius: Get.width * .1,
            child: Icon(
              Icons.upload,
              size: Get.width * .1,
              color: Colors.white,
            ),
            backgroundColor: Colors.purple,
          ),
          onTap: () async {
            PickedFile? pickedFile = await ImagePicker().getImage(
              source: ImageSource.gallery,
            );
            setState(() {
              imageFile = File(pickedFile!.path);
            });

            print(imageFile.toString());
          },
        ),
      );
    } else {
      return Center(
        child: Image.file(
          imageFile,
          fit: BoxFit.fitWidth,
        ),
      );
    }
  }
}
