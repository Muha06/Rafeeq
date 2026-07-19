// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quran_goal_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranGoalHiveAdapter extends TypeAdapter<QuranGoalHive> {
  @override
  final int typeId = 10;

  @override
  QuranGoalHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranGoalHive(
      target: fields[0] as int,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      isActive: fields[3] as bool,
      type: fields[4] as QuranGoalTypeHive,
      targetUnit: fields[7] as QuranTargetUnitHive,
      reminderHour: fields[5] as int?,
      reminderMinute: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, QuranGoalHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.target)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.reminderHour)
      ..writeByte(6)
      ..write(obj.reminderMinute)
      ..writeByte(7)
      ..write(obj.targetUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranGoalHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
