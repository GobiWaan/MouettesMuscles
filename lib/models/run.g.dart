// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RunAdapter extends TypeAdapter<Run> {
  @override
  final int typeId = 1;

  @override
  Run read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Run(
      id: fields[0] as DateTime?,
      date: fields[1] as DateTime?,
      week: fields[2] as int,
      runMinutes: fields[3] as int,
      walkMinutes: fields[4] as int,
      cycles: fields[5] as int,
      totalTime: fields[6] as int?,
      feeling: fields[7] as String,
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Run obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.week)
      ..writeByte(3)
      ..write(obj.runMinutes)
      ..writeByte(4)
      ..write(obj.walkMinutes)
      ..writeByte(5)
      ..write(obj.cycles)
      ..writeByte(6)
      ..write(obj.totalTime)
      ..writeByte(7)
      ..write(obj.feeling)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
