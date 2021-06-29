import 'package:better_assignments/slidable_widgets/editTile.dart';
import 'package:better_assignments/slidable_widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'bools.dart';
import 'delete.dart';

class Sliding extends StatefulWidget {
  final bool isComp;
  final bool isStar;
  Sliding({required this.isComp, required this.isStar});

  @override
  _SlidingState createState() => _SlidingState();
}

class _SlidingState extends State<Sliding> {
  final assignBox = Hive.box("assignBox");

  @override
  Widget build(BuildContext context) {
    return _listView();
  }

  Widget _listView() {
    if (assignBox.isEmpty) {
      return Center(
        child: Text("Press + to add an assignment!"),
      );
    } else
      return ListView.builder(
        itemCount: assignBox.length,
        itemBuilder: (BuildContext context, int index) {
          if (widget.isComp == true &&
              assignBox.getAt(index).isComplete == true &&
              widget.isStar == false) {
          } else if (widget.isComp == false &&
              assignBox.getAt(index).isComplete == false &&
              widget.isStar == false) {
          } else if (widget.isComp == false &&
              assignBox.getAt(index).isComplete == false &&
              widget.isStar == true &&
              assignBox.getAt(index).isStar) {
          } else {
            return SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              closeOnScroll: true,

              // Favourite slide action
              actions: [
                SlideAction(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
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
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(0),
                      right: Radius.circular(30),
                    ),
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
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
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
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
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
        },
      );
  }
}
