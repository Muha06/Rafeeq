// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllahNameHiveAdapter extends TypeAdapter<AllahNameHive> {
  @override
  final int typeId = 30;

  @override
  AllahNameHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllahNameHive(
      number: fields[0] as int,
      nameAr: fields[1] as String,
      transliteration: fields[2] as String,
      meaningEn: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AllahNameHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.nameAr)
      ..writeByte(2)
      ..write(obj.transliteration)
      ..writeByte(3)
      ..write(obj.meaningEn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllahNameHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
