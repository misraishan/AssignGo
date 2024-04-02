// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignModelAdapter extends TypeAdapter<Assignment> {
  @override
  final int typeId = 0;

  @override
  Assignment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assignment(
      title: fields[0] as String,
      date: fields[2] as String,
      desc: fields[1] as String,
      subject: fields[3] as String,
      isComplete: fields[4] as bool,
      isStar: fields[5] as bool,
      notifIDLong: fields[6] as int,
      notifIDShort: fields[7] as int,
      notifIDStar: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Assignment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.desc)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.isComplete)
      ..writeByte(5)
      ..write(obj.isStar)
      ..writeByte(6)
      ..write(obj.notifIDLong)
      ..writeByte(7)
      ..write(obj.notifIDShort)
      ..writeByte(8)
      ..write(obj.notifIDStar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
