import 'package:assigngo/settings/notification_service.dart';
import 'package:assigngo/settings/theme.dart';
import 'package:assigngo/subjects/subject.dart';
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
          _tile(Icon(Icons.subject), "Subjects", Subject()),
          _tile(Icon(Icons.palette_outlined), "Theme", ThemeEngine()),
          GetPlatform.isIOS
              ? _tile(
                  Icon(Icons.notifications), "Notification", Notifications())
              : SizedBox.shrink(),
          _tile(Icon(Icons.copyright), "About", About()),
        ],
      ),
    );
  }
}

Widget _tile(Icon icon, String title, Widget page) {
  return InkWell(
    child: Container(
      height: 100,
      padding: EdgeInsets.all(10),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Container(width: 10),
            Text(
              title,
              style: Get.context!.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    ),
    onTap: () => Get.to(() => page),
  );
}
