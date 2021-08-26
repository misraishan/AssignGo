import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    applicationName: "AssignGo",
    values: {
      'version': 'Release 1.0',
      'year': DateTime.now().year.toString(),
    },
    //  applicationLegalese: 'Copyright © Ishan Misra, {{ year }}',
    applicationDescription: TextButton(
        onPressed: () async {
          await launch("https://hayhay.cc");
        },
        child: Text("Visit the website!")),
    children: <Widget>[
      MarkdownPageListTile(
        icon: Icon(Icons.list),
        title: const Text('Changelog'),
        filename: 'CHANGELOG.md',
      ),
      LicensesPageListTile(
        icon: Icon(Icons.favorite),
      ),
      ListTile(
        leading: Icon(Icons.privacy_tip),
        title: Text("Privacy Policy"),
        onTap: () async {
          await launch("https://google.com");
        },
      ),
      ListTile(
        leading: Icon(Icons.feedback),
        title: Text("Send feedback"),
        onTap: () async {
          String? encodeQueryParameters(Map<String, String> params) {
            return params.entries
                .map((e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                .join('&');
          }

          await launch(Uri(
            scheme: "mailto",
            path: "info@hayhay.cc",
            query: encodeQueryParameters(
              <String, String>{
                'subject': 'Example Subject & Symbols are allowed!',
                'body': 'Release 1.0',
              },
            ),
          ).toString());
        },
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
