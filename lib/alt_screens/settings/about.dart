import 'package:about/about.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showAbout(),
    );
  }
}

Widget _showAbout() {
  return AboutPage(
    values: {
      'version': 'Alpha 1.0',
      'year': DateTime.now().year.toString(),
    },
    applicationLegalese: 'Copyright © Ishan Misra, {{ year }}',
    applicationDescription: const Text(''),
    children: <Widget>[
      MarkdownPageListTile(
        icon: Icon(Icons.list),
        title: const Text('Changelog'),
        filename: 'CHANGELOG.md',
      ),
      LicensesPageListTile(
        icon: Icon(Icons.favorite),
      ),
    ],
    applicationIcon: const SizedBox(
      width: 100,
      height: 100,
      child: Image(
        image: AssetImage('images/app_icon.png'),
      ),
    ),
  );
}
