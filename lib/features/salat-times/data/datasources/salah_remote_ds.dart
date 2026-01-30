import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/features/salat-times/data/models/salah_times_model.dart';

abstract class SalahRemoteDataSource {
  Future<AladhanTimingsModel> fetchTodayByCity({
    required String city,
    required String country,
    int method,
  });

  Future<AladhanTimingsModel> fetchTodayByCoords({
    required double latitude,
    required double longitude,
    int method,
  });
}

class SalahRemoteDataSourceImpl implements SalahRemoteDataSource {
  final http.Client client;

  const SalahRemoteDataSourceImpl(this.client);

  @override
  Future<AladhanTimingsModel> fetchTodayByCity({
    required String city,
    required String country,
    int method = 3,
  }) async {
    final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity', {
      'city': city,
      'country': country,
      'method': method.toString(),
    });

    debugPrint("$country, $city");

    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch timings: ${res.statusCode}');
    }

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;
    final data = jsonMap['data'] as Map<String, dynamic>;

    final timingsJson = data['timings'] as Map<String, dynamic>; //salat timings
    final metaJson =
        data['meta'] as Map<String, dynamic>; // meatadata: timezones
    final dateJson =
        data['date'] as Map<String, dynamic>; // date when sending report

    return AladhanTimingsModel.fromJson(
      timingsJson: timingsJson,
      metaJson: metaJson,
      dateJson: dateJson,
    );
  }

  //By coords
  @override
  Future<AladhanTimingsModel> fetchTodayByCoords({
    required double latitude,
    required double longitude,
    int method = 3,
  }) async {
    final uri = Uri.https('api.aladhan.com', '/v1/timings', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'method': method.toString(),
    });

    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch timings: ${res.statusCode}');
    }

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;
    final data = jsonMap['data'] as Map<String, dynamic>;

    final timingsJson = data['timings'] as Map<String, dynamic>;
    final metaJson = data['meta'] as Map<String, dynamic>;
    final dateJson = data['date'] as Map<String, dynamic>;

    return AladhanTimingsModel.fromJson(
      timingsJson: timingsJson,
      metaJson: metaJson,
      dateJson: dateJson,
    );
  }
}
