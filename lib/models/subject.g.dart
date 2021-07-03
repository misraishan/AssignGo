// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 1;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      title: fields[0] as String,
      color: fields[1] as int,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
