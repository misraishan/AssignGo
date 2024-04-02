import 'package:assigngo/models/assignment.dart';
import 'package:assigngo/assignments/assignmentItem.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final assignBox = Hive.box("assignBox");
  final subjBox = Hive.box("subjBox");
  final searchController = TextEditingController();
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchResults = assignBox.values
            .cast<Assignment>()
            .where((element) => element.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();

        searchResults.forEach((element) {
          print(element.title);
        });
      });
    });
  }

  void updateList() {
    setState(() {
      // update your list here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          final Assignment assignment = searchResults[index];
          return AssignmentItem(
              index: assignBox.values.toList().indexOf(assignment),
              isStar: assignment.isStar,
              isComp: assignment.isComplete,
              onUpdate: updateList);
        },
      ),
    );
  }
}
