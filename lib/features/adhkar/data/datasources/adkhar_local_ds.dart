import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import '../models/dhikr_hive_model.dart';

class DhikrLocalDataSource {
  final Box<List<dynamic>> _box;

  DhikrLocalDataSource(this._box);

  /// Save list of DhikrHiveModels for a subcategory
  Future<void> saveAdhkar(
    int subcategoryId, //eg 28
    List<DhikrHiveModel> dhikrs,
  ) async {
    debugPrint("Saving to hive");

    await _box.put(subcategoryId, dhikrs);
  }

  /// Fetch list of DhikrHiveModels for a subcategory
  List<DhikrHiveModel>? getAdhkar(int subcategoryId) {
    final data = _box.get(subcategoryId);
    if (data != null) {
      return (data).cast<DhikrHiveModel>();
    }
    return null;
  }

  /// Optional: clear cache
  Future<void> clearCache() async {
    await _box.clear();
  }
}
