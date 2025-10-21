// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeightAdapter extends TypeAdapter<Weight> {
  @override
  final int typeId = 2;

  @override
  Weight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weight(
      id: fields[0] as DateTime?,
      date: fields[1] as DateTime?,
      weightLbs: fields[2] as double,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Weight obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.weightLbs)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
