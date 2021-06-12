import 'package:hive/hive.dart';

part 'assignment.g.dart';

@HiveType(typeId: 0)
class AssignModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String? desc;
  @HiveField(2)
  String date;
  @HiveField(3)
  String? subject;

  AssignModel({
    required this.title,
    required this.date,
    this.desc,
    this.subject,
  });
}
