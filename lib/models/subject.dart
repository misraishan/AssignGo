import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String color;

  Subject({required this.name, required this.color});
}
