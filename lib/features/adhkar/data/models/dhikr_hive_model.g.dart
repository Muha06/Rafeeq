// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DhikrHiveModelAdapter extends TypeAdapter<DhikrHiveModel> {
  @override
  final int typeId = 0;

  @override
  DhikrHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DhikrHiveModel(
      id: fields[0] as int,
      categoryTitle: fields[1] as String,
      arabicText: fields[2] as String,
      transliteration: fields[3] as String,
      translation: fields[4] as String,
      repeat: fields[5] as int,
      audioUrl: fields[6] as String,
      categoryId: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DhikrHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryTitle)
      ..writeByte(2)
      ..write(obj.arabicText)
      ..writeByte(3)
      ..write(obj.transliteration)
      ..writeByte(4)
      ..write(obj.translation)
      ..writeByte(5)
      ..write(obj.repeat)
      ..writeByte(6)
      ..write(obj.audioUrl)
      ..writeByte(7)
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
