import 'package:better_assignments/models/assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    var result;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Completed assignments",
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
        child: ListView.builder(
          itemCount: assignBox.length,
          itemBuilder: (BuildContext context, int index) {
            if (assignBox.getAt(index).isComplete == true) {
              result = Padding(
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
                        //TODO: Make this switch between true & false, must do for all of them/all pages
                        assignBox.getAt(index).isStar = true;
                        setState(
                          () {},
                        );
                      },
                    ),
                  ],
                  // Delete slide action
                  secondaryActions: [
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
                            assignBox.deleteAt(index);
                          },
                        );
                      },
                    ),
                  ],
                  child: ListTile(
                    tileColor: Colors.black,
                    title: Text(assignBox.getAt(index).title),
                    subtitle: Text(assignBox.getAt(index).desc),
                  ),
                ),
              );
            } else {
              result = Container();
            }
            return result;
          },
        ),
      ),
    );
  }
}
