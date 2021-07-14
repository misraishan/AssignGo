import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeEngine extends StatefulWidget {
  @override
  _ThemeEngineState createState() => _ThemeEngineState();
}

class _ThemeEngineState extends State<ThemeEngine> {
  ThemeMode _themeMode = ThemeMode.dark;
  final _prefs = Hive.box("prefs");

  bool _isDark = true;
  @override
  void initState() {
    super.initState();
    _isDark = _prefs.get('isDark', defaultValue: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.palette_outlined),
            Container(width: 5),
            Text("Theming"),
          ],
        ),
      ),
      body: Column(
        children: [
          /*  Text(
            "Warning! This is experimental right now!\nIt may cause bugs.",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
            textAlign: TextAlign.center,
          ),
          */
          SwitchListTile(
            title: _isDark ? Text("Dark theme") : Text("Light Theme"),
            secondary: _isDark ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
            value: _isDark,
            onChanged: (value) {
              value
                  ? _themeMode = ThemeMode.dark
                  : _themeMode = ThemeMode.light;

              setState(() {
                _isDark = value;
                _prefs.put('isDark', _isDark);
                Get.changeThemeMode(_themeMode);
              });
            },
          ),
        ],
      ),
    );
  }
}
