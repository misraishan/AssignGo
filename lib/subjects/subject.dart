import 'package:assigngo/subjects/new_subj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class Subject extends StatefulWidget {
  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final subjBox = Hive.box("subjBox");
  final assignBox = Hive.box("assignBox");

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
                  return newSubj(true, null);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                await Get.dialog(newSubj(true, null));
                setState(() {});
              },
              icon: Icon(Icons.add),
              iconSize: 100,
            ),
            Text("Click to add a new Subject"),
          ],
        ),
        //child: newSubj(true, null),
      );
    } else {
      return ListView.builder(
        itemCount: subjBox.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Slidable(
              // actionPane: SlidableScrollActionPane(),
              // actions: [
              //   SlideAction(
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(30.0),
              //       ),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.delete),
              //         Text("Delete"),
              //       ],
              //     ),
              //     onTap: () async {
              //       await Get.dialog(_delete(index));
              //       setState(
              //         () {},
              //       );
              //     },
              //   ),
              // ],
              // secondaryActions: [
              //   SlideAction(
              //     decoration: BoxDecoration(
              //       color: Colors.purple,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(30.0),
              //       ),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.edit),
              //         Text("Edit"),
              //       ],
              //     ),
              //     onTap: () async {
              //       await showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return newSubj(false, index);
              //         },
              //       );
              //       setState(() {});
              //     },
              //   ),
              // ],
              child: Card(
                color: Color(subjBox.getAt(index).color),
                child: Container(
                  height: 75,
                  child: Center(
                    child: _centerBuilder(index),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _centerBuilder(int index) {
    final _name = subjBox.getAt(index).name;
    final _email = subjBox.getAt(index).email;
    if (_name != "" || _email != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            subjBox.getAt(index).title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _name != ""
              ? Text(
                  subjBox.getAt(index).name,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              : SizedBox.shrink(),
          _email != ""
              ? InkWell(
                  child: Text(
                    subjBox.getAt(index).email,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: _email,
                    );
                    launch(_emailLaunchUri.toString());
                  },
                )
              : SizedBox.shrink(),
        ],
      );
    }
    return Text(
      subjBox.getAt(index).title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _delete(int index) {
    final assignBox = Hive.box('assignBox');
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      title: Text(
        "Are you sure you want to delete this subject?",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Container(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  var _subjName = subjBox.getAt(index).title;

                  if (assignBox.isNotEmpty) {
                    var _assign = "";

                    for (int i = 0; i < assignBox.length; i++) {
                      _assign = assignBox.getAt(i).subject;
                      if (_assign.compareTo(_subjName) == 0) {
                        assignBox.getAt(i).subject = "";
                      }
                    }
                  }
                  subjBox.deleteAt(index);
                  Get.back();
                  setState(() {});
                },
                child: Text("Confirm"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            )
          ],
        ),
      ],
    );

    return alert;
  }
}
