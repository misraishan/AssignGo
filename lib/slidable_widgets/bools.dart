import 'package:hive/hive.dart';

class Bools {
  final assignBox = Hive.box('assignBox');
  void isStar(index) {
    assignBox.getAt(index).isStar
        ? assignBox.getAt(index).isStar = false
        : assignBox.getAt(index).isStar = true;
  }

  void isComp(index) {
    assignBox.getAt(index).isComplete
        ? assignBox.getAt(index).isComplete = false
        : assignBox.getAt(index).isComplete = true;
  }
}
