import 'package:better_assignments/subjects/new_subj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class Subject extends StatefulWidget {
  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final subjBox = Hive.box("subjBox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Icon(Icons.subject),
            ),
            Text("Subjects"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return newSubj("", "", "0xffAB47BC");
                },
              );
              setState(() {});
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _newSubjBuilder(),
    );
  }

  Widget _newSubjBuilder() {
    if (subjBox.isEmpty) {
      return Center(
        child: newSubj("", "", "0xFFAB47BC"),
      );
    } else {
      return ListView.builder(
        itemCount: subjBox.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableScrollActionPane(),
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
                onTap: () {},
              ),
            ],
            child: ListTile(
              title: Text(subjBox.getAt(index).name),
              //tileColor: subjBox.getAt(index).color,
            ),
          );
        },
      );
    }
  }
}
