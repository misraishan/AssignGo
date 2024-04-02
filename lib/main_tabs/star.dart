import 'package:better_assignments/slidable_widgets/assignmentsList.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:better_assignments/main.dart';

class Star extends StatefulWidget {
  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    setState(() {});
    super.initState();
  }

  final assignBox = Hive.box('assignBox');

  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
          pinned: _pinned,
          snap: _snap,
          floating: _floating,
          expandedHeight: 150.0,
          centerTitle: false,
          backgroundColor: Colors.orange,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              child: Opacity(
                opacity: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.orange,
                        Colors.amber,
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
                'Prioritized',
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
      page: PageType.star,
    );
  }
}
