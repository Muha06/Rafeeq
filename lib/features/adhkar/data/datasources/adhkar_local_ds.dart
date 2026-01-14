import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rafeeq/features/adhkar/data/models/dhikr_model.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class AdhkarLocalDataSource {
  /// Loads a list of adhkar from an asset json file path, e.g.
  /// "assets/adhkar/general.json"
  Future<List<DhikrModel>> loadAdhkarFromAsset(String assetPath);
}

class AdhkarLocalDsImpl implements AdhkarLocalDataSource {
  @override
  Future<List<DhikrModel>> loadAdhkarFromAsset(String assetPath) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonStr);

    if (decoded is! List) {
      throw FormatException('Expected a JSON array in $assetPath');
    }

    // Cast safely then parse
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(DhikrModel.fromJson)
        .toList(growable: false);
  }
}
