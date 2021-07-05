import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:hive/hive.dart';

class Bools {
  final assignBox = Hive.box('assignBox');
  void isStar(index) async {
    var _isStar = await assignBox.getAt(index).isStar
        ? assignBox.getAt(index).isStar = false
        : assignBox.getAt(index).isStar = true;

    // TODO: New notification with 3rd channel if prioritized
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
        subject: assignBox.getAt(index).subject,
      ),
    );
  }
}
