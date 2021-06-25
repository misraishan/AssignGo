import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        leading: Icon(
          Icons.home,
          size: 30,
          color: Colors.purple,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Future update 😉",
                  backgroundColor: Colors.indigo,
                );
              },
              icon: Icon(Icons.subject)),
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Future update 😉",
                  backgroundColor: Colors.indigo,
                );
              },
              icon: Icon(Icons.calendar_today)),
        ],
        title: Text("Assignments"),
      ),
      //   body: itemBuild()
      body: _listItem(),
    );
  }

/*

 -----------------------------------------------------------------------------------------------------------------
 List Item builder
 -----------------------------------------------------------------------------------------------------------------
 */

  Widget _listItem() {
    return Sliding(
      isComp: false,
      isStar: false,
    );
  }
}

/*

  Widget _listItem() {
    return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
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
                    setState(
                      () {
                        Bools().isStar(index);
                      },
                    );
                  },
                ),
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
                    setState(
                      () {
                        Bools().isComp(index);
                      },
                    );
                  },
                ),
              ],
              // Delete & Edit slide action
              secondaryActions: [
                SlideAction(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      Text("Edit"),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                  onTap: () {
                    Get.bottomSheet(editTile(index));
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
                    await Get.dialog(delete(index));
                    setState(() {});
                  },
                ),
              ],
              child: tiles(index),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
*/