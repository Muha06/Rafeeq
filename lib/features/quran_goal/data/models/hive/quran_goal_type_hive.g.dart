// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_goal_type_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranGoalTypeHiveAdapter extends TypeAdapter<QuranGoalTypeHive> {
  @override
  final int typeId = 14;

  @override
  QuranGoalTypeHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuranGoalTypeHive.tilawah;
      case 1:
        return QuranGoalTypeHive.hifz;
      default:
        return QuranGoalTypeHive.tilawah;
    }
  }

  @override
  void write(BinaryWriter writer, QuranGoalTypeHive obj) {
    switch (obj) {
      case QuranGoalTypeHive.tilawah:
        writer.writeByte(0);
        break;
      case QuranGoalTypeHive.hifz:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranGoalTypeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
