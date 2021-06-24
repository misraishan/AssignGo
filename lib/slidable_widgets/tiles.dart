import 'package:better_assignments/slidable_widgets/delete.dart';
import 'package:better_assignments/slidable_widgets/editTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

Icon _starIcon = Icon(
  Icons.star,
  color: Colors.amber,
);
Icon _assignIcon = Icon(
  Icons.assignment,
  color: Colors.white,
);

class Tiles extends StatefulWidget {
  final int index = 0;
  const Tiles(index);

  @override
  _TilesState createState() => _TilesState();
}

class _TilesState extends State<Tiles> {
  final assignBox = Hive.box('assignBox');
  @override
  Widget build(BuildContext context) {
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
                  assignBox.getAt(widget.index).isStar
                      ? assignBox.getAt(widget.index).isStar = false
                      : assignBox.getAt(widget.index).isStar = true;
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
            onTap: () async {
              await assignBox.getAt(widget.index).isComplete
                  ? assignBox.getAt(widget.index).isComplete = false
                  : assignBox.getAt(widget.index).isComplete = true;
              print("test");

              setState(() {});
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
            ),
            onTap: () {
              Get.bottomSheet(editTile(widget.index));
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
              await Get.dialog(delete(widget.index));
              setState(() {});
            },
          ),
        ],
        child: ListTile(
          leading:
              assignBox.getAt(widget.index).isStar ? _starIcon : _assignIcon,
          isThreeLine: true,
          tileColor: Colors.black,
          title: Text("${assignBox.getAt(widget.index).title}"),
          subtitle: Text(
              "${assignBox.getAt(widget.index).date} \n ${assignBox.getAt(widget.index).desc}"),
        ),
      ),
    );
  }
}
