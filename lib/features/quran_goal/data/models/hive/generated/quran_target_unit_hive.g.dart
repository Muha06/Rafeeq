// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quran_target_unit_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranTargetUnitHiveAdapter extends TypeAdapter<QuranTargetUnitHive> {
  @override
  final int typeId = 13;

  @override
  QuranTargetUnitHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuranTargetUnitHive.ayah;
      case 1:
        return QuranTargetUnitHive.page;
      case 2:
        return QuranTargetUnitHive.juz;
      case 3:
        return QuranTargetUnitHive.surah;
      default:
        return QuranTargetUnitHive.ayah;
    }
  }

  @override
  void write(BinaryWriter writer, QuranTargetUnitHive obj) {
    switch (obj) {
      case QuranTargetUnitHive.ayah:
        writer.writeByte(0);
        break;
      case QuranTargetUnitHive.page:
        writer.writeByte(1);
        break;
      case QuranTargetUnitHive.juz:
        writer.writeByte(2);
        break;
      case QuranTargetUnitHive.surah:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranTargetUnitHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
