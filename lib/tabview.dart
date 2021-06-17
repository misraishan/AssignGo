import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:date_time_picker/date_time_picker.dart';
import 'package:nanoid/nanoid.dart';

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
 -----------------------------------------------------------------------------------------------------------------
 */
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final assignBox = Hive.box('assignBox');

  dynamic _panel() {
    _title.clear();
    _desc.clear();
    _date.clear();

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
                    DateTimePicker(
                      type: DateTimePickerType.dateTime,
                      dateMask: 'dd / MM / yy - hh : mm',
                      use24HourFormat: false,
                      controller: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                      icon: Icon(Icons.cloud_circle),
                      decoration: InputDecoration(
                        labelText: "Due Date & time",
                        prefixIcon: Icon(Icons.calendar_today),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (val) {
                        _date.text = val;
                      },
                    ),

                    // Subject selection
                    Container(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.subject),
                      label: Text("Subject"),
                    ),

                    // Submit button selection
                    Container(height: 20),
                    TextButton.icon(
                      onPressed: () {
                        if (_date.text == "") {
                          Fluttertoast.showToast(
                              msg: "Date can't be empty.",
                              backgroundColor: Colors.red);
                        } else {
                          setState(
                            () {
                              // Generates a new number 9 digits long.
                              // Converts _date.text to DateTime to use for schedule notifications
                              DateTime _dateDue = DateTime.parse(_date.text);
                              final DateTime _longDur =
                                  _dateDue.subtract(Duration(hours: 12));

                              final DateTime _shortDur =
                                  _dateDue.subtract(Duration(minutes: 30));
                              int _id =
                                  int.parse(customAlphabet('1234567890', 9));
                              // Create first notification (12 hrs from deadline)
                              AwesomeNotifications().createNotification(
                                content: NotificationContent(
                                  id: _id,
                                  channelKey: '12hr',
                                  title: _title.text,
                                  body: _desc.text,
                                  displayOnBackground: true,
                                ),
                                schedule: NotificationCalendar(
                                  allowWhileIdle: true,
                                  year: _longDur.year,
                                  month: _longDur.month,
                                  hour: _longDur.hour,
                                  minute: _longDur.minute,
                                  day: _longDur.day,
                                ),
                              );

                              // TODO: Create notification 30 minute before.
                              if (_title.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Title can't be empty.",
                                    backgroundColor: Colors.red);
                              } else {
                                assignBox.add(
                                  AssignModel(
                                    title: _title.text,
                                    date: _date.text,
                                    desc: _desc.text,
                                    isComplete: false,
                                    isStar: false,
                                    notifID: _id,
                                  ),
                                );
                                Navigator.popAndPushNamed(context, "/");
                              }
                            },
                          );
                        }
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
