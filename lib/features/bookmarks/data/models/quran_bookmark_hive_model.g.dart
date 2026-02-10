// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_bookmark_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranBookmarkHiveModelAdapter
    extends TypeAdapter<QuranBookmarkHiveModel> {
  @override
  final int typeId = 31;

  @override
  QuranBookmarkHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranBookmarkHiveModel(
      id: fields[0] as String,
      surahId: fields[1] as int,
      surahEnglishName: fields[2] as String,
      ayahNumber: fields[3] as int,
      createdAtMillis: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, QuranBookmarkHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.surahId)
      ..writeByte(2)
      ..write(obj.surahEnglishName)
      ..writeByte(3)
      ..write(obj.ayahNumber)
      ..writeByte(4)
      ..write(obj.createdAtMillis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranBookmarkHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
