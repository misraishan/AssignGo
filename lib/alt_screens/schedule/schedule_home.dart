import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.schedule),
            Container(
              width: 10,
            ),
            Text("Schedule"),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
