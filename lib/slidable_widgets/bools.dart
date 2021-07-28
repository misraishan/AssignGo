import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:hive/hive.dart';

class Bools {
  final assignBox = Hive.box('assignBox');
  void isStar(index) async {
    var _isStar = await assignBox.getAt(index).isStar
        ? assignBox.getAt(index).isStar = false
        : assignBox.getAt(index).isStar = true;

    if (_isStar) {
      final DateTime _starDur = DateTime.parse(assignBox.getAt(index).date);
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
      AssignModel(
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
      AssignModel(
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
}
