import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rafeeq/core/location/domain/open_mateo.dart';
 
/// ----------------------
/// Data source
/// ----------------------
class OpenMeteoGeocodingDs {
  OpenMeteoGeocodingDs(this._client);
  final http.Client _client;

  Future<List<GeoPlace>> search({
    required String name,
    required String countryCode, // KE, TZ, etc
    int count = 10,
  }) async {
    final q = name.trim();
    if (q.isEmpty) return const [];

    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': q,
      'count': '$count',
      'language': 'en',
      'format': 'json',
      'country': countryCode,
    });

    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Geocoding failed (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List?) ?? const [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(GeoPlace.fromJson)
        .toList(growable: false);
  }
}
