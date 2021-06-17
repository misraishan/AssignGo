import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/home.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:better_assignments/models/subject.dart';
import 'package:better_assignments/tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Set path for storage and initalize Hive directory
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();

  // Set orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Hive :D
  Hive.init(appDir.path);

  // Register all necessary adapters (Subject & Assignment Adapter)
  Hive.registerAdapter(
    AssignModelAdapter(),
  );
  Hive.registerAdapter(
    SubjectAdapter(),
  );

  // Open new box, subjBox for subjects, assignBox for assignments
  await Hive.openBox("subjBox");
  await Hive.openBox("assignBox");

  // FOR NOTIFICATIONS
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: '30_min',
        channelName: 'short warning',
        channelDescription: 'Notification channel for default assignments',
        defaultColor: Colors.purple,
        vibrationPattern: lowVibrationPattern,
      ),
      NotificationChannel(
        channelKey: '12hr',
        channelName: 'long warning',
        channelDescription: 'All assignments 12hr before',
        defaultColor: Colors.purple,
        vibrationPattern: lowVibrationPattern,
      ),
      NotificationChannel(
        channelKey: 'priority_channel',
        channelName: 'Priority notifications',
        channelDescription: 'Notification channel for prioritized assignments',
        defaultColor: Colors.red,
        enableVibration: true,
        vibrationPattern: highVibrationPattern,
      )
    ],
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      /*AlertDialog(
        title: Text('Notifications'),
        content: Text(
            'Do we have your permission to send notifications? We promise it helps!'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('No thanks!'),
          ),
          TextButton(
            autofocus: true,
            onPressed: () {},
            child: Text('Sure thing!'),
          ),
        ],
      );*/
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Contains all necessary routes + theme related stuff
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Assignments',
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => TabView(),
        "/home": (context) => Home(),
      },
    );
  }

  void dispose() {
    Hive.close();
  }
}
