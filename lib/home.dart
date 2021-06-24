import 'package:better_assignments/slidable_widgets/bools.dart';
import 'package:better_assignments/slidable_widgets/delete.dart';
import 'package:better_assignments/slidable_widgets/editTile.dart';
import 'package:better_assignments/slidable_widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Assignments",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: false,
      ),
      //   body: itemBuild()
      body: _listItem(),
    );
  }

  Widget itemBuild() {
    return GetBuilder(builder: (int index) {
      return Text("Test");
    });
    /* return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        if (!assignBox.getAt(index).isComplete) {
          return Tiles(index);
        } else {
          return Container();
        }
      },
    );*/
  }

/*

 -----------------------------------------------------------------------------------------------------------------
 List Item builder
 -----------------------------------------------------------------------------------------------------------------
 */

  static Icon _starIcon = Icon(
    Icons.star,
    color: Colors.amber,
  );
  static Icon _assignIcon = Icon(
    Icons.assignment,
    color: Colors.white,
  );

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
              child: ListTile(
                leading:
                    assignBox.getAt(index).isStar ? _starIcon : _assignIcon,
                isThreeLine: true,
                tileColor: Colors.black,
                title: Text("${assignBox.getAt(index).title}"),
                subtitle: Text(
                    "${assignBox.getAt(index).date} \n ${assignBox.getAt(index).desc}"),
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
