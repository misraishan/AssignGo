import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/alt_screens/IntroScreen.dart';
import 'package:better_assignments/alt_screens/star.dart';
import 'package:better_assignments/home.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:better_assignments/models/subject.dart';
import 'package:better_assignments/tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen = 0;
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

  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);

  // FOR NOTIFICATIONS
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'short',
        channelName: 'short warning',
        channelDescription: '6 hours before due.',
        enableVibration: true,
        vibrationPattern: highVibrationPattern,
      ),
      NotificationChannel(
        channelKey: 'long',
        channelName: 'long warning',
        channelDescription: '24 hours before due',
        defaultColor: Colors.purple,
        vibrationPattern: lowVibrationPattern,
        enableVibration: true,
      ),
      // TODO: Decide how long priority notif should be
      NotificationChannel(
        channelKey: 'medium',
        channelName: 'Priority notifications',
        channelDescription: 'Notification channel for prioritized assignments',
        defaultColor: Colors.red,
        enableVibration: true,
        vibrationPattern: mediumVibrationPattern,
      )
    ],
  );

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Contains all necessary routes + theme related stuff
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Better Assignments',
      //themeMode: ThemeMode.system,
      defaultTransition: Transition.upToDown,
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Colors.grey[900],
        // TimePicker theme
        timePickerTheme: TimePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        // Bottom Sheet theme
        bottomSheetTheme: BottomSheetThemeData(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ),

        // Text Themes
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyText1: TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
        ),
        // Appbar theme
        appBarTheme: AppBarTheme(
          centerTitle: false,
          color: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
        ),
        // Card theme
        cardTheme: CardTheme(
          color: Colors.grey[850],
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),

      initialRoute: initScreen == 0 || initScreen == null ? "/intro" : "/",
      routes: {
        "/": (context) => TabView(),
        "/home": (context) => Home(),
        "/intro": (context) => IntroScreen(),
        "/star": (context) => Star(),
      },
    );
  }

  void dispose() {
    Hive.close();
  }
}

// TODO: Gpa Calculator
// Use google assistant to add new assignments?
// Add more w/ assignments => new page
