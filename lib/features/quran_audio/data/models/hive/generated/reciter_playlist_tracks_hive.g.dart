// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reciter_playlist_tracks_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReciterPlaylistTracksHiveAdapter
    extends TypeAdapter<ReciterPlaylistTracksHive> {
  @override
  final int typeId = 37;

  @override
  ReciterPlaylistTracksHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReciterPlaylistTracksHive(
      reciterId: fields[0] as int,
      tracks: (fields[1] as List).cast<SurahTrackHive>(),
      cachedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReciterPlaylistTracksHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.reciterId)
      ..writeByte(1)
      ..write(obj.tracks)
      ..writeByte(2)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReciterPlaylistTracksHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
