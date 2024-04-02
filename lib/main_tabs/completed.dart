import 'package:better_assignments/slidable_widgets/assignmentsList.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:better_assignments/main.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> with RouteAware {
  final assignBox = Hive.box('assignBox');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    setState(() {});
    super.initState();
  }

  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
          backgroundColor: Colors.green,
          pinned: _pinned,
          snap: _snap,
          floating: _floating,
          expandedHeight: 150.0,
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              child: Opacity(
                opacity: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.green, Colors.lightGreen],
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
                'Completed',
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
      page: PageType.completed,
    );
  }
}
