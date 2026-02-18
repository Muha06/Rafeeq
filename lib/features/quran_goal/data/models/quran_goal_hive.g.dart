// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_goal_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranHiveGoalAdapter extends TypeAdapter<QuranHiveGoal> {
  @override
  final int typeId = 10;

  @override
  QuranHiveGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranHiveGoal(
      dailyTarget: fields[0] as int,
      createdAt: fields[1] as DateTime,
      isActive: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuranHiveGoal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dailyTarget)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranHiveGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
