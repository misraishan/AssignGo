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
  bool isComplete = false;
  @HiveField(5)
  bool isStar = false;
  @HiveField(6)
  int notifID = 0;

  AssignModel({
    this.title = "",
    this.date = "",
    this.desc = "",
    this.subject = "",
    this.isComplete = false,
    this.isStar = false,
    this.notifID = 0,
  });
}
