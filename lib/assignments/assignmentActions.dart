import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:assigngo/models/assignment.dart';
import 'package:hive/hive.dart';

/// A class that contains methods for handling assignment actions (star, complete).
class AssignmentActions {
  final assignBox = Hive.box('assignBox');

  /// Toggles the star status of an assignment at the given index.
  ///
  /// If the assignment is starred, it will be unstarred, and vice versa.
  /// If the assignment is starred, a notification will be scheduled to remind the user 2 days before the assignment's date.
  /// If the assignment is unstarred, the scheduled notification will be canceled.
  ///
  /// [index] - The index of the assignment in the assignBox.
  void isStar(index) async {
    Assignment assignment = await assignBox.getAt(index);
    var _isStar = await assignment.isStar
        ? assignment.isStar = false
        : assignment.isStar = true;

    if (_isStar) {
      final DateTime _starDur =
          DateTime.parse(assignment.date).subtract(Duration(days: 2));
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: assignment.notifIDStar,
          channelKey: 'star',
          title: assignment.title,
          body: assignment.desc,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar(
          allowWhileIdle: true,
          year: _starDur.year,
          month: _starDur.month,
          hour: _starDur.hour,
          minute: _starDur.minute,
          day: _starDur.day,
        ),
      );
    } else {
      AwesomeNotifications().cancel(assignment.notifIDStar);
    }

    assignBox.putAt(
      index,
      assignment,
    );
  }

  /// Toggles the completion status of an assignment at the given index.
  ///
  /// If the assignment is marked as complete, it will be marked as incomplete, and vice versa.
  /// If the assignment is marked as complete, any scheduled notifications for the assignment will be canceled.
  ///
  /// [index] - The index of the assignment in the assignBox.
  void isComp(index) async {
    Assignment assignment = await assignBox.getAt(index);
    var _isComp = assignment.isComplete
        ? assignment.isComplete = false
        : assignment.isComplete = true;

    if (_isComp) {
      AwesomeNotifications().cancel(assignment.notifIDLong);
      AwesomeNotifications().cancel(assignment.notifIDShort);
    }
    assignBox.putAt(index, assignment);
  }

  Future<void> delete(index) async {
    Assignment assignment = await assignBox.getAt(index);
    AwesomeNotifications().cancel(assignment.notifIDLong);
    AwesomeNotifications().cancel(assignment.notifIDShort);
    await assignBox.deleteAt(index);
  }
}
