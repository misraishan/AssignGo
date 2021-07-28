import 'package:hive/hive.dart';
part 'assignment.g.dart';

@HiveType(typeId: 0)
class AssignModel {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String desc = "";
  @HiveField(2)
  String date = "";
  @HiveField(3)
  String subject;
  @HiveField(4)
  bool isComplete;
  @HiveField(5)
  bool isStar;
  @HiveField(6)
  int notifIDLong;
  @HiveField(7)
  int notifIDShort;
  @HiveField(8)
  int notifIDStar;

  AssignModel({
    this.title = "",
    this.date = "",
    this.desc = "",
    this.subject = "",
    this.isComplete = false,
    this.isStar = false,
    this.notifIDLong = 0,
    this.notifIDShort = 0,
    this.notifIDStar = 0,
  });
}
