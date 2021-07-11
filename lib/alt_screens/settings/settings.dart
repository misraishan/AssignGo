import 'package:better_assignments/alt_screens/settings/theme.dart';
import 'package:better_assignments/subjects/subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.settings,
          size: 30,
          color: Colors.blue,
        ),
        title: Text(
          "Settings",
        ),
      ),
      body: Column(
        children: [
          InkWell(
            child: Container(
              height: 100,
              padding: EdgeInsets.all(10),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.subject),
                    Container(width: 10),
                    Text(
                      "Subjects",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => Get.to(() => Subject()),
          ),

          // Theming Page
          InkWell(
            child: Container(
              height: 100,
              padding: EdgeInsets.all(10),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.palette_outlined),
                    Container(width: 10),
                    Text(
                      "Theme",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => Get.to(() => ThemeEngine()),
          ),

          // Show About Page
          InkWell(
            child: Container(
              height: 100,
              padding: EdgeInsets.all(10),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copyright),
                    Container(width: 10),
                    Text(
                      "About",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => Get.to(() => About()),
          ),
        ],
      ),
    );
  }
}
