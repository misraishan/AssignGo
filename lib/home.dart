import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Creates box to store the assignments & subjects
  final assignBox = Hive.box('assignBox');
  final subjBox = Hive.box('subjBox');

  // Controls radius of borders for the panel when shown
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Assignments",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: false,
      ),
      body: EasyRefresh(
        onLoad: () async {
          setState(
            () {
              Fluttertoast.showToast(msg: "Refreshed.");
            },
          );
        },
        child: _listItem(),
      ),
    );
  }

/*

 -----------------------------------------------------------------------------------------------------------------
 List Item builder
 -----------------------------------------------------------------------------------------------------------------
 */

  Widget _listItem() {
    return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        print(assignBox.getAt(index).isComplete);
        if (assignBox.getAt(index).isComplete == false) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              // Favourite slide action
              actions: [
                SlideAction(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      Text("Prioritize"),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      assignBox.getAt(index).isStar = true;
                    });
                  },
                ),
              ],
              // Delete & complete slide action
              secondaryActions: [
                SlideAction(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box),
                      Text("Mark as done"),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  onTap: () {
                    setState(() {
                      assignBox.getAt(index).isComplete = true;
                    });
                  },
                ),
                SlideAction(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      Text("Delete"),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      assignBox.deleteAt(index);
                    });
                  },
                ),
              ],
              child: ListTile(
                isThreeLine: true,
                tileColor: Colors.black,
                title: Text(assignBox.getAt(index).title),
                subtitle: Text(assignBox.getAt(index).desc),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
