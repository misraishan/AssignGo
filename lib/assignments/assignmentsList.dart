import 'package:assigngo/assignments/assignmentItem.dart';
import 'package:assigngo/modals/assignmentModal.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    void updateList() {
      setState(() {
        // update your list here
      });
    }

    return SliverList.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        final _assignment = assignBox.getAt(index);
        final _isComp = _assignment.isComplete;
        final _isStar = _assignment.isStar;

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

        return AssignmentItem(
            index: index,
            isStar: _isStar,
            isComp: _isComp,
            onUpdate: updateList);
      },
    );
  }
}
