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

  // Execute runApp
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
