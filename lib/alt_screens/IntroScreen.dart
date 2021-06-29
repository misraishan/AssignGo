import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:better_assignments/subjects/new_subj.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final assignBox = Hive.box("assignBox");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntroductionScreen(
          showNextButton: false,
          done: ElevatedButton(
            onPressed: () {
              assignBox.add(
                AssignModel(
                  isStar: true,
                  date: DateTime.now().toString().padLeft(2, '0'),
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
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Colors.green,
                              ),
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
          doneColor: Colors.black,
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
      titleWidget: newSubj("", "", "0xFFAB47BC"),
      //title: "You can sort by subjects, and color code all your assignments!",
      body: "Create a subject here:",
      //bodyWidget: newSubj()
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
