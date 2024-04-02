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
    var _isStar = await assignBox.getAt(index).isStar
        ? assignBox.getAt(index).isStar = false
        : assignBox.getAt(index).isStar = true;

    if (_isStar) {
      final DateTime _starDur =
          DateTime.parse(assignBox.getAt(index).date).subtract(
        Duration(days: 2),
      );
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: assignBox.getAt(index).notifIDStar,
          channelKey: 'star',
          title: assignBox.getAt(index).title,
          body: assignBox.getAt(index).desc,
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
      AwesomeNotifications().cancel(assignBox.getAt(index).notifIDStar);
    }

    assignBox.putAt(
      index,
      Assignment(
        isStar: _isStar,
        title: assignBox.getAt(index).title,
        desc: assignBox.getAt(index).desc,
        date: assignBox.getAt(index).date,
        isComplete: assignBox.getAt(index).isComplete,
        notifIDLong: assignBox.getAt(index).notifIDLong,
        notifIDShort: assignBox.getAt(index).notifIDShort,
        notifIDStar: assignBox.getAt(index).notifIDStar,
        subject: assignBox.getAt(index).subject,
      ),
    );
  }

  /// Toggles the completion status of an assignment at the given index.
  ///
  /// If the assignment is marked as complete, it will be marked as incomplete, and vice versa.
  /// If the assignment is marked as complete, any scheduled notifications for the assignment will be canceled.
  ///
  /// [index] - The index of the assignment in the assignBox.
  void isComp(index) async {
    var _isComp = await assignBox.getAt(index).isComplete
        ? assignBox.getAt(index).isComplete = false
        : assignBox.getAt(index).isComplete = true;

    if (_isComp) {
      AwesomeNotifications().cancel(assignBox.getAt(index).notifIDLong);
      AwesomeNotifications().cancel(assignBox.getAt(index).notifIDShort);
    }
    assignBox.putAt(
      index,
      Assignment(
        isStar: assignBox.getAt(index).isStar,
        title: assignBox.getAt(index).title,
        desc: assignBox.getAt(index).desc,
        date: assignBox.getAt(index).date,
        isComplete: _isComp,
        notifIDLong: assignBox.getAt(index).notifIDLong,
        notifIDShort: assignBox.getAt(index).notifIDShort,
        notifIDStar: assignBox.getAt(index).notifIDStar,
        subject: assignBox.getAt(index).subject,
      ),
    );
  }

  Future<void> delete(index) async {
    Assignment assignment = assignBox.getAt(index);
    AwesomeNotifications().cancel(assignment.notifIDLong);
    AwesomeNotifications().cancel(assignment.notifIDShort);
    await assignBox.deleteAt(index);
  }
}
