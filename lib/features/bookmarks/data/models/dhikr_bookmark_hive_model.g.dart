// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_bookmark_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DhikrBookmarkHiveModelAdapter
    extends TypeAdapter<DhikrBookmarkHiveModel> {
  @override
  final int typeId = 32;

  @override
  DhikrBookmarkHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DhikrBookmarkHiveModel(
      dhikrId: fields[0] as String,
      dhikrTitle: fields[1] as String,
      createdAtMillis: fields[2] as int,
      assetPath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DhikrBookmarkHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dhikrId)
      ..writeByte(1)
      ..write(obj.dhikrTitle)
      ..writeByte(2)
      ..write(obj.createdAtMillis)
      ..writeByte(3)
      ..write(obj.assetPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrBookmarkHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
