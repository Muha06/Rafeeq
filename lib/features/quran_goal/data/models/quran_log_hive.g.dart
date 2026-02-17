// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_log_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranHiveLogAdapter extends TypeAdapter<QuranHiveLog> {
  @override
  final int typeId = 11;

  @override
  QuranHiveLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranHiveLog(
      date: fields[0] as DateTime,
      ayahsRead: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, QuranHiveLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.ayahsRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranHiveLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
