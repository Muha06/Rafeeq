import 'package:rafeeq/features/asma_ul_husna/data/models/name_model.dart';

import 'dart:convert';

import 'package:flutter/services.dart';

abstract class AllahNamesLocalDataSource {
  Future<List<AllahNameModel>> getAllahNames();
}

class AllahNamesLocalDataSourceImpl implements AllahNamesLocalDataSource {
  const AllahNamesLocalDataSourceImpl();

  static const _assetPath = 'assets/json/allah_names.json';

 @override
  Future<List<AllahNameModel>> getAllahNames() async {
    final jsonString = await rootBundle.loadString(_assetPath);

    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    final names = json['asmaul_husna'] as List<dynamic>;

    return names
        .map((item) => AllahNameModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
