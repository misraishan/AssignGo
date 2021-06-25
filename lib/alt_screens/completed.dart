import 'package:better_assignments/slidable_widgets/sliding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Completed extends StatefulWidget {
  Completed({Key? key}) : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  final assignBox = Hive.box('assignBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.check_box,
          size: 30,
          color: Colors.green,
        ),
        title: Text("Completed assignments"),
      ),
      body: _listItem(),
    );
  }

  Widget _listItem() {
    return Sliding(
      isComp: true,
      isStar: false,
    );
  }
}
  /*

  Widget _listItem() {
    return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        if (assignBox.getAt(index).isComplete == true) {
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