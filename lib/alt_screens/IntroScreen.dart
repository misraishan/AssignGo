import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:better_assignments/subjects/new_subj.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:intl/intl.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final assignBox = Hive.box("assignBox");
  final prefs = Hive.box("prefs");

  String formattedDate = "";
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  void _dateNow() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  @override
  Widget build(BuildContext context) {
    prefs.put("firstLaunch", 1);
    _dateNow();
    return Scaffold(
      body: Center(
        child: IntroductionScreen(
          showNextButton: false,
          done: ElevatedButton(
            onPressed: () {
              assignBox.add(
                AssignModel(
                  isStar: true,
                  date: formattedDate,
                  title:
                      "Add a new assignment with the plus button at the bottom!",
                  desc: "This is an assignment description. "
                      "You can make it as long or as short as you'd like!"
                      "\n\nSwipe right to prioritize or complete an assignment, and swipe left to edit or delete!",
                ),
              );
              AwesomeNotifications().isNotificationAllowed().then(
                (isAllowed) {
                  if (!isAllowed) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          title: Text(
                            'Notification permissions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                              'Do we have your permission to send notifications? We promise it will help!'),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text("Cancel"),
                                    style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    autofocus: true,
                                    onPressed: () {
                                      AwesomeNotifications()
                                          .requestPermissionToSendNotifications();
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text('Sure thing!'),
                                    style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(width: 5),
                          ],
                        );
                      },
                    );
                  }
                },
              );
              Navigator.popAndPushNamed(context, "/");
            },
            child: Text("Get started!"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => Colors.black,
              ),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                (_) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  );
                },
              ),
            ),
          ),
          doneStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => Colors.black,
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (_) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                );
              },
            ),
          ),
          globalBackgroundColor: Colors.blue,
          pages: _pages,
          onDone: () {},
        ),
      ),
    );
  }

  List<PageViewModel> _pages = [
    PageViewModel(
      image: Image.asset("images/icon_transparent.png"),
      title: "An ad-free, Assignment tracker designed for you!",
      body: "Manage all your assignments in one place easily!" +
          "\nPrioritize, sort, and complete your assignments with plenty of time remaining!",
    ),
    PageViewModel(
      titleWidget: newSubj(true, null),
      body: "Create a subject here:",
    ),
    PageViewModel(
      image: Image.asset("images/Slidables.png"),
      title: "With a single swipe",
      body: "You can prioritize, complete, delete, and edit assignments!",
    ),
    PageViewModel(
      image: Image.asset("images/Notific_IOS.png"),
      title: "Get notified",
      body:
          "24 hours and 1 hour before your assignment is due, so you never miss a deadline!",
    ),
  ];
}
