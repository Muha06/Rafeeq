import 'package:hive/hive.dart';

class HijriOffsetStorage {
  static const _boxName = 'settingsBox';
  static const _key = 'hijri_offset_days';

  Box get _box => Hive.box(_boxName);

  int readOffset() {
    return (_box.get(_key, defaultValue: 0) as int).clamp(-2, 2);
  }

  Future<void> writeOffset(int value) async {
    final clamped = value.clamp(-2, 2);
    await _box.put(_key, clamped);
  }
}
