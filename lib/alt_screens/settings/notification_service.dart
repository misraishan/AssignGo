import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

final _prefs = Hive.box("prefs");

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.notifications),
            Container(width: 5),
            Text("Notifications"),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            _prefs.get("notificationAllowed", defaultValue: false) == false
                ? TextButton(
                    onPressed: () {
                      check();
                    },
                    child: Text("Turn on notifications?"),
                  )
                : Center(
                    child: Text("Nothing here yet!"),
                  ),
          ],
        ),
      ),
    );
  }
}

void check() {
  AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              title: Text(
                'Notification permissions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                  'Do we have your permission to send notifications? We promise it will help!'),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _prefs.put("notificationAllowed", false);
                          Get.back();
                        },
                        child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        autofocus: true,
                        onPressed: () {
                          _prefs.put("notificationAllowed", true);
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications();
                          Get.back();
                        },
                        child: Text('Sure thing!'),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(width: 5),
              ],
            );
          },
        );
      }
    },
  );
}
