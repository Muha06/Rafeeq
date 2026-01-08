// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AyahHiveAdapter extends TypeAdapter<AyahHive> {
  @override
  final int typeId = 2;

  @override
  AyahHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AyahHive(
      id: fields[0] as int,
      surahId: fields[1] as int,
      ayahNumber: fields[2] as int,
      textArabic: fields[3] as String,
      textEnglish: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AyahHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.surahId)
      ..writeByte(2)
      ..write(obj.ayahNumber)
      ..writeByte(3)
      ..write(obj.textArabic)
      ..writeByte(4)
      ..write(obj.textEnglish);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
