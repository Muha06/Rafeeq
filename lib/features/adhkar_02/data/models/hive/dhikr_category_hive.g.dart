// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_category_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DhikrCategoryHiveAdapter extends TypeAdapter<DhikrCategoryHive> {
  @override
  final int typeId = 33;

  @override
  DhikrCategoryHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DhikrCategoryHive(
      id: fields[0] as String,
      title: fields[1] as String,
      slug: fields[2] as String,
      sortOrder: fields[3] as int,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DhikrCategoryHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.sortOrder)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrCategoryHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
