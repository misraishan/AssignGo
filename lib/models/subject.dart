import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String color;
  @HiveField(2)
  String name;
  Subject({required this.title, this.color = "", this.name = ""});
}
