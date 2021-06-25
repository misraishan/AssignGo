import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Get.changeTheme(
                  Get.isDarkMode ? ThemeData() : ThemeData(),
                );
                print("Theme");
              },
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.color_lens),
                    Container(width: 10),
                    Text(
                      "Theme",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(10),
            child: Card(
              color: Colors.black,
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
        ],
      ),
    );
  }
}
