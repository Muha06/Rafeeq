// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../surah_track_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahTrackHiveAdapter extends TypeAdapter<SurahTrackHive> {
  @override
  final int typeId = 38;

  @override
  SurahTrackHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahTrackHive(
      trackId: fields[0] as String,
      surahId: fields[1] as int,
      surahName: fields[2] as String,
      reciterId: fields[3] as int,
      reciterName: fields[4] as String,
      url: fields[5] as String,
      audioFileId: fields[6] as int?,
      fileSize: fields[7] as double?,
      format: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SurahTrackHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.trackId)
      ..writeByte(1)
      ..write(obj.surahId)
      ..writeByte(2)
      ..write(obj.surahName)
      ..writeByte(3)
      ..write(obj.reciterId)
      ..writeByte(4)
      ..write(obj.reciterName)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.audioFileId)
      ..writeByte(7)
      ..write(obj.fileSize)
      ..writeByte(8)
      ..write(obj.format);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahTrackHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
