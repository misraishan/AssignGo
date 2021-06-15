import 'package:better_assignments/alt_screens/completed.dart';
import 'package:better_assignments/alt_screens/settings.dart';
import 'package:better_assignments/alt_screens/star.dart';
import 'package:better_assignments/home.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: 60,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(30.0),
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style10, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      Star(),
      Home(),
      Completed(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.star),
        title: ("Prioritized"),
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.amber,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: ("Add"),
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
        onPressed: (context) {
          _panel();
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.check_box),
        title: ("Completed"),
        activeColorPrimary: Colors.green,
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.blue,
        textStyle: TextStyle(color: Colors.blue),
        activeColorSecondary: Colors.white,
      ),
    ];
  }

  /*







 -----------------------------------------------------------------------------------------------------------------
 Panel
 */
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final assignBox = Hive.box('assignBox');

  dynamic _panel() {
    _title.clear();
    _desc.clear();

    final result = showModalBottomSheet(
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
                              assignBox.add(
                                AssignModel(
                                  title: _title.text,
                                  date: DateTime.now(),
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
                      label: Text("Add assignment"),
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

    return result;
  }
}
