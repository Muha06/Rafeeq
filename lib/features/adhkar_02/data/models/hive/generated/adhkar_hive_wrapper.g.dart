// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../adhkar_hive_wrapper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdhkarHiveWrapperAdapter extends TypeAdapter<AdhkarHiveWrapper> {
  @override
  final int typeId = 36;

  @override
  AdhkarHiveWrapper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdhkarHiveWrapper(
      categoryId: fields[0] as String,
      cachedAt: fields[1] as DateTime,
      dhikrs: (fields[2] as List).cast<DhikrHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdhkarHiveWrapper obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.cachedAt)
      ..writeByte(2)
      ..write(obj.dhikrs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdhkarHiveWrapperAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
