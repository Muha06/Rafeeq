// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../dhikr_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DhikrHiveModelAdapter extends TypeAdapter<DhikrHiveModel> {
  @override
  final int typeId = 34;

  @override
  DhikrHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DhikrHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      arabicText: fields[2] as String,
      englishText: fields[3] as String,
      transliteration: fields[4] as String?,
      repeat: fields[5] as int,
      sortOrder: fields[6] as int,
      audioUrl: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      categoryId: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DhikrHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.arabicText)
      ..writeByte(3)
      ..write(obj.englishText)
      ..writeByte(4)
      ..write(obj.transliteration)
      ..writeByte(5)
      ..write(obj.repeat)
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.audioUrl)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
