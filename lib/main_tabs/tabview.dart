import 'package:assigngo/main_tabs/completed.dart';
import 'package:assigngo/alt_screens/settings/settings.dart';
import 'package:assigngo/main_tabs/star.dart';
import 'package:assigngo/main_tabs/home.dart';
import 'package:assigngo/modals/searchModal.dart';
import 'package:assigngo/modals/assignmentModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    Home(),
    Star(),
    Home(),
    Completed(),
    Settings(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Call the assignModal function when the add button is tapped
      await assignModal(true, null, "");
    } else {
      // Update the selected index for other buttons
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        persistentFooterButtons: [
          Padding(
              child: TextField(
                onTap: () {
                  // Call the assignModal function when the search bar is tapped
                  Get.to(() => SearchModal());
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom))
        ],
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: _onItemTapped,
            selectedIndex: _selectedIndex,
            indicatorColor: Colors.purple,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.star), label: "Prioritized"),
              NavigationDestination(icon: Icon(Icons.add), label: "Add"),
              NavigationDestination(
                  icon: Icon(Icons.check_box), label: "Completed"),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: "Settings"),
            ]));
  }
}
