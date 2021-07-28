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
  int count = 0;

  @override
  Widget build(BuildContext context) {
    _checkCompletePlusButton();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32.5),
      child:
          (assignBox.isEmpty || (count == assignBox.length && !widget.isComp))
              ? _plusButton()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _listView(),
                      Container(height: Get.height / 5),
                      _checkPlusButton()
                    ],
                  ),
                ),
    );
  }

  void _checkCompletePlusButton() {
    count = 0;
    for (int index = 0; index < assignBox.length; index++) {
      if (assignBox.getAt(index).isComplete) count++;
    }
  }

  Widget _checkPlusButton() {
    if (assignBox.isNotEmpty &&
        widget.isComp == false &&
        widget.isStar == false) {
      return _plusButton();
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _plusButton() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              if (widget.subjSelect != "") {
                print("hi");
                await assignModal(true, null, widget.subjSelect);
              } else
                await assignModal(true, null, "");
              setState(() {});
            },
            icon: Icon(Icons.add),
            iconSize: 100,
          ),
          Text("Add a new assignment!"),
        ],
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        final bool _isComp = assignBox.getAt(index).isComplete;
        final bool _isStar = assignBox.getAt(index).isStar;
        if (widget.isComp == true &&
            _isComp == true &&
            widget.isStar == false) {
        } else if (widget.isComp == false &&
            _isComp == false &&
            widget.isStar == false) {
        } else if (widget.isComp == false &&
            _isComp == false &&
            widget.isStar == true &&
            _isStar) {
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
                    _isStar
                        ? Icon(Icons.star)
                        : Icon(Icons.star_border_outlined),
                    _isStar
                        ? Text("Un-prioritize", textAlign: TextAlign.center)
                        : Text("Prioritize", textAlign: TextAlign.center),
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
                    _isComp
                        ? Icon(Icons.check_box_outlined)
                        : Icon(Icons.check_box),
                    _isComp
                        ? Text("Mark incomplete", textAlign: TextAlign.center)
                        : Text("Mark as done", textAlign: TextAlign.center),
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
                onTap: () async {
                  await assignModal(false, index, "");
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
