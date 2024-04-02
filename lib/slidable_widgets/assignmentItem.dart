import 'package:better_assignments/slidable_widgets/assignmentModal.dart';
import 'package:better_assignments/slidable_widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'bools.dart';
import 'delete.dart';

class AssignmentItem extends StatefulWidget {
  const AssignmentItem({
    Key? key,
    required this.index,
    required this.isStar,
    required this.isComp,
    required this.onUpdate,
  });

  final int index;
  final bool isStar;
  final bool isComp;
  final Function onUpdate;

  @override
  State<AssignmentItem> createState() => _AssignmentItemState();
}

class _AssignmentItemState extends State<AssignmentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Slidable(
        child: tiles(widget.index),
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
              icon: widget.isStar ? Icons.star : Icons.star_border_outlined,
              label: widget.isStar ? "Un-prioritize" : "Prioritize",
              onPressed: (context) async => {
                Bools().isStar(widget.index),
                widget.onUpdate(),
              }, // Update the isStar bool then refresh the state
            ),
            // Slide action for deletion
            SlidableAction(
              onPressed: (context) async => {
                await Get.dialog(delete(
                    widget.index)), // Await for the response from the dialog
                widget.onUpdate(),
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
            icon: widget.isComp ? Icons.check_box_outlined : Icons.check_box,
            label: widget.isComp ? "Mark incomplete" : "Mark as done",
            onPressed: (context) async => {
              Bools().isComp(widget.index),
              widget.onUpdate(),
            },
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
            onPressed: (context) async => {
              await assignModal(false, widget.index, ""),
              widget.onUpdate(),
            },
          ),
        ]),
      ),
    );
  }
}
