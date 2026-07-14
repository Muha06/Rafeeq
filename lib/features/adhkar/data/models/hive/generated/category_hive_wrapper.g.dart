// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../category_hive_wrapper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryCacheHiveAdapter extends TypeAdapter<CategoryCacheHive> {
  @override
  final int typeId = 35;

  @override
  CategoryCacheHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryCacheHive(
      cachedAt: fields[0] as DateTime,
      categories: (fields[1] as List).cast<DhikrCategoryHive>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryCacheHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cachedAt)
      ..writeByte(1)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryCacheHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
