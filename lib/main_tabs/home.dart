import 'package:better_assignments/slidable_widgets/assignmentsList.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Creates box to store the assignments & subjects
  final assignBox = Hive.box('assignBox');

  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 150.0,
              centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.purple,
                            Colors.indigo,
                            Colors.blue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Assignments',
                    textScaler: TextScaler.linear(1.1),
                  ),
                ),
              ),
            ),
            _listItem(),
          ]),
    );
  }

  Widget _listItem() {
    return AssignmentsList(
      page: PageType.home,
    );
  }
}
