import 'package:better_assignments/models/assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Creates box to store the assignments & subjects
  final assignBox = Hive.box('assignBox');
  final subjBox = Hive.box('subjBox');

  // Controls radius of borders for the panel when shown
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
          IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today)),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Assignments",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: false,
      ),
      body: EasyRefresh(
        onLoad: () async {
          setState(
            () {
              Fluttertoast.showToast(msg: "Refreshed.");
            },
          );
        },
        child: _listItem(),
      ),
    );
  }

/*

 -----------------------------------------------------------------------------------------------------------------
 List Item builder
 -----------------------------------------------------------------------------------------------------------------
 */

  static Icon _starIcon = Icon(
    Icons.star,
    color: Colors.amber,
  );
  static Icon _assignIcon = Icon(
    Icons.assignment,
    color: Colors.white,
  );

  Widget _listItem() {
    return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        if (assignBox.getAt(index).isComplete == false) {
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
                        // AwesomeNotifications().removeChannel(channelKey);
                        assignBox.getAt(index).isStar
                            ? assignBox.getAt(index).isStar = false
                            : assignBox.getAt(index).isStar = true;
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
                        assignBox.getAt(index).isComplete
                            ? assignBox.getAt(index).isComplete = false
                            : assignBox.getAt(index).isComplete = true;
                      },
                    );
                  },
                ),
              ],
              // Delete & complete slide action
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
                    setState(() {
                      _editTile(index);
                    });
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
                    setState(
                      () {
                        AlertDialog alert = AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          title: Text(
                            "Are you sure you want to delete this assignment?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: Text("Cancel"),
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Colors.red,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    assignBox.deleteAt(index);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                );
                              },
                              child: Text("Confirm"),
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Colors.green,
                              ),
                            )
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                    );
                  },
                ),
              ],
              child: ListTile(
                leading:
                    assignBox.getAt(index).isStar ? _starIcon : _assignIcon,
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

  /*

 -----------------------------------------------------------------------------------------------------------------
 Item Editor
 -----------------------------------------------------------------------------------------------------------------
 */
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  Widget _editTile(int index) {
    _title.text = assignBox.getAt(index).title;
    _desc.text = assignBox.getAt(index).desc;
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.black,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    // Title
                    Container(height: 20),
                    TextField(
                      controller: _title,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.assignment),
                        labelText: "Assignment name",
                      ),
                    ),

                    // Description
                    Container(height: 20),
                    TextField(
                      controller: _desc,
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.assignment),
                        labelText: "Description",
                      ),
                    ),

                    // Due date selection
                    Container(height: 20),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_today),
                      label: Text("Due Date"),
                    ),

                    // Submit button selection
                    Container(height: 20),
                    TextButton.icon(
                      onPressed: () {
                        setState(
                          () {
                            if (_title.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Title can't be empty",
                                  backgroundColor: Colors.red);
                            } else {
                              assignBox.putAt(
                                index,
                                AssignModel(
                                  title: _title.text,
                                  date: "",
                                  desc: _desc.text,
                                  isComplete: false,
                                  isStar: false,
                                ),
                              );

                              Navigator.popAndPushNamed(context, "/");
                            }
                          },
                        );
                      },
                      icon: Icon(Icons.done),
                      label: Text("Edit Assignment"),
                    ),
                    Container(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Container();
  }
}
