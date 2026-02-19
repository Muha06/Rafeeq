// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahHiveAdapter extends TypeAdapter<SurahHive> {
  @override
  final int typeId = 1;

  @override
  SurahHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahHive(
      id: fields[0] as int,
      nameArabic: fields[1] as String,
      nameEnglish: fields[2] as String,
      nameTransliteration: fields[3] as String,
      isMeccan: fields[4] as bool,
      versesCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SurahHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameArabic)
      ..writeByte(2)
      ..write(obj.nameEnglish)
      ..writeByte(3)
      ..write(obj.nameTransliteration)
      ..writeByte(4)
      ..write(obj.isMeccan)
      ..writeByte(5)
      ..write(obj.versesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
