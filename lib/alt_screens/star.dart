import 'package:better_assignments/slidable_widgets/bools.dart';
import 'package:better_assignments/slidable_widgets/delete.dart';
import 'package:better_assignments/slidable_widgets/editTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Star extends StatefulWidget {
  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> {
  final assignBox = Hive.box('assignBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.star,
          size: 30,
          color: Colors.amber,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Prioritized assignments",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: false,
      ),
      body: _listItem(),
    );
  }

  Widget _listItem() {
    return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        if (assignBox.getAt(index).isStar &&
            !assignBox.getAt(index).isComplete) {
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
                leading: _starIcon,
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

  static Icon _starIcon = Icon(
    Icons.star,
    color: Colors.amber,
  );
}
