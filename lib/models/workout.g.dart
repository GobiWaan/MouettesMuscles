// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 0;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      id: fields[0] as DateTime?,
      date: fields[1] as DateTime?,
      type: fields[2] as String,
      pullups1: fields[3] as int?,
      pullups2: fields[4] as int?,
      pullups2Negatives: fields[5] as int?,
      pullups2NegativesFinal: fields[6] as int?,
      bicepsCurls: fields[7] as int?,
      bicepsCurlsNegatives: fields[8] as int?,
      dipsOrPike: fields[9] as String?,
      dips1: fields[10] as int?,
      dips2: fields[11] as int?,
      dips2Negatives: fields[12] as int?,
      dips2NegativesFinal: fields[13] as int?,
      pike1: fields[14] as int?,
      pike2: fields[15] as int?,
      pike2Negatives: fields[16] as int?,
      pike2NegativesFinal: fields[17] as int?,
      squatOrDeadlift: fields[18] as String?,
      squat1: fields[19] as int?,
      squat2: fields[20] as int?,
      squat3: fields[21] as int?,
      squat1Weight: fields[32] as double?,
      squat2Weight: fields[33] as double?,
      deadlift1: fields[22] as int?,
      deadlift2: fields[23] as int?,
      deadlift2Negatives: fields[24] as int?,
      deadlift1Weight: fields[34] as double?,
      deadlift2Weight: fields[35] as double?,
      backExtension: fields[26] as int?,
      legRaises: fields[27] as int?,
      qlExtension: fields[28] as int?,
      backExtension2: fields[29] as int?,
      legRaises2: fields[30] as int?,
      qlExtension2: fields[31] as int?,
      notes: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(36)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.pullups1)
      ..writeByte(4)
      ..write(obj.pullups2)
      ..writeByte(5)
      ..write(obj.pullups2Negatives)
      ..writeByte(6)
      ..write(obj.pullups2NegativesFinal)
      ..writeByte(7)
      ..write(obj.bicepsCurls)
      ..writeByte(8)
      ..write(obj.bicepsCurlsNegatives)
      ..writeByte(9)
      ..write(obj.dipsOrPike)
      ..writeByte(10)
      ..write(obj.dips1)
      ..writeByte(11)
      ..write(obj.dips2)
      ..writeByte(12)
      ..write(obj.dips2Negatives)
      ..writeByte(13)
      ..write(obj.dips2NegativesFinal)
      ..writeByte(14)
      ..write(obj.pike1)
      ..writeByte(15)
      ..write(obj.pike2)
      ..writeByte(16)
      ..write(obj.pike2Negatives)
      ..writeByte(17)
      ..write(obj.pike2NegativesFinal)
      ..writeByte(18)
      ..write(obj.squatOrDeadlift)
      ..writeByte(19)
      ..write(obj.squat1)
      ..writeByte(20)
      ..write(obj.squat2)
      ..writeByte(21)
      ..write(obj.squat3)
      ..writeByte(32)
      ..write(obj.squat1Weight)
      ..writeByte(33)
      ..write(obj.squat2Weight)
      ..writeByte(22)
      ..write(obj.deadlift1)
      ..writeByte(23)
      ..write(obj.deadlift2)
      ..writeByte(24)
      ..write(obj.deadlift2Negatives)
      ..writeByte(34)
      ..write(obj.deadlift1Weight)
      ..writeByte(35)
      ..write(obj.deadlift2Weight)
      ..writeByte(26)
      ..write(obj.backExtension)
      ..writeByte(27)
      ..write(obj.legRaises)
      ..writeByte(28)
      ..write(obj.qlExtension)
      ..writeByte(29)
      ..write(obj.backExtension2)
      ..writeByte(30)
      ..write(obj.legRaises2)
      ..writeByte(31)
      ..write(obj.qlExtension2)
      ..writeByte(25)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
