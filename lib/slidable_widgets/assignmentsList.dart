import 'package:better_assignments/slidable_widgets/assign_widgets.dart';
import 'package:better_assignments/slidable_widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'bools.dart';
import 'delete.dart';

enum PageType { home, star, completed }

class AssignmentsList extends StatefulWidget {
  final PageType page;

  AssignmentsList({
    required this.page,
  });

  @override
  _AssignmentItemActions createState() => _AssignmentItemActions();
}

class _AssignmentItemActions extends State<AssignmentsList> {
  final assignBox = Hive.box("assignBox");
  final subjBox = Hive.box("subjBox");
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return (assignBox.isEmpty) ? _addNewAssignment() : _listView();
  }

  Widget _addNewAssignment() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  await assignModal(true, null, "");
                  setState(() {});
                },
                icon: Icon(Icons.add),
                iconSize: 100,
              ),
              Text("Add a new assignment!"),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _listView() {
    return SliverList.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        final bool _isComp = assignBox.getAt(index).isComplete;
        final bool _isStar = assignBox.getAt(index).isStar;

        if (widget.page == PageType.home) {
          if ((_isComp)) {
            return SizedBox.shrink();
          }
        } else if (widget.page == PageType.star) {
          if (_isStar == false || _isComp) {
            return SizedBox.shrink();
          }
        } else if (widget.page == PageType.completed) {
          if (_isComp == false) {
            return SizedBox.shrink();
          }
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Slidable(
            child: tiles(index),
            closeOnScroll: true,
            // Favourite slide action
            startActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                // Slide action for prioritizing
                SlidableAction(
                  backgroundColor: Colors.amber,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  icon: _isStar ? Icons.star : Icons.star_border_outlined,
                  label: _isStar ? "Un-prioritize" : "Prioritize",
                  onPressed: (context) async => {
                    Bools().isStar(index),
                    setState(() {})
                  }, // Update the isStar bool then refresh the state
                ),
                // Slide action for deletion
                SlidableAction(
                  onPressed: (context) async => {
                    await Get.dialog(delete(
                        index)), // Await for the response from the dialog
                    setState(() {}) // Update the state
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: "Delete",
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
              ],
            ),

            endActionPane: ActionPane(motion: ScrollMotion(), children: [
              // Slide action for marking as done
              SlidableAction(
                backgroundColor: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                icon: _isComp ? Icons.check_box_outlined : Icons.check_box,
                label: _isComp ? "Mark incomplete" : "Mark as done",
                onPressed: (context) async =>
                    {Bools().isComp(index), setState(() {})},
              ),
              // Slide action for editing
              SlidableAction(
                backgroundColor: Colors.purple,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(0),
                  right: Radius.circular(30.0),
                ),
                icon: Icons.edit,
                label: "Edit",
                onPressed: (context) async =>
                    {await assignModal(false, index, ""), setState(() {})},
              ),
            ]),
          ),
        );
      },
    );
  }
}
