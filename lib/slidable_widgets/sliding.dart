import 'package:better_assignments/slidable_widgets/assign_widgets.dart';
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
  final String subjSelect;
  Sliding({
    required this.isComp,
    required this.isStar,
    this.subjSelect = "",
  });

  @override
  _SlidingState createState() => _SlidingState();
}

class _SlidingState extends State<Sliding> {
  final assignBox = Hive.box("assignBox");
  final subjBox = Hive.box("subjBox");

  @override
  Widget build(BuildContext context) {
    return _listView();
  }

  Widget _listView() {
    if (assignBox.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                assignModal(true, null);
              },
              icon: Icon(Icons.add),
              iconSize: 100,
            ),
            Text("Add a new assignment!"),
          ],
        ),
      );
    } else {
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

          if (widget.subjSelect.compareTo("") == 0) {
          } else {
            for (int i = 0; i < subjBox.length; i++) {
              String assignSubj = assignBox.getAt(index).subject;
              if (widget.subjSelect.compareTo(assignSubj) == 0) {
              } else {
                return SizedBox.shrink();
              }
            }
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
                      Flexible(child: Text("Prioritize")),
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

                // Mark as done slidable
                SlideAction(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box),
                      Text("Mark as done", textAlign: TextAlign.center),
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

              // Edit slide action
              secondaryActions: [
                SlideAction(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      Flexible(child: Text("Edit")),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  onTap: () async {
                    await assignModal(false, index);
                    setState(() {});
                  },
                ),

                // Delete slide action
                SlideAction(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      Flexible(child: Text("Delete")),
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
}
