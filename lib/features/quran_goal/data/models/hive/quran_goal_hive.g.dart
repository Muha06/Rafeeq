// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_goal_hive.dart';

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
      dailyTarget: fields[0] as int,
      createdAt: fields[6] as DateTime,
      isActive: fields[1] as bool,
      type: fields[2] as QuranGoalTypeHive,
      targetUnit: fields[5] as QuranTargetUnitHive,
      reminderHour: fields[3] as int?,
      reminderMinute: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, QuranGoalHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dailyTarget)
      ..writeByte(1)
      ..write(obj.isActive)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.reminderHour)
      ..writeByte(4)
      ..write(obj.reminderMinute)
      ..writeByte(5)
      ..write(obj.targetUnit)
      ..writeByte(6)
      ..write(obj.createdAt);
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
