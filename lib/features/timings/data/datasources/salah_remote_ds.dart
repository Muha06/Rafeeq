import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rafeeq/features/timings/data/models/salah_times_model.dart';

abstract class SalahRemoteDataSource {
  Future<List<AladhanTimingsModel>> fetchMonthByCoordinates({
    required double latitude,
    required double longitude,
    int method = 3,
  });
}

class SalahRemoteDataSourceImpl implements SalahRemoteDataSource {
  final http.Client client;

  const SalahRemoteDataSourceImpl(this.client);

  //By coords
  @override
  Future<List<AladhanTimingsModel>> fetchMonthByCoordinates({
    required double latitude,
    required double longitude,
    int method = 3,
  }) async {
    final now = DateTime.now();

    final uri =
        Uri.https('api.aladhan.com', '/v1/calendar/${now.year}/${now.month}', {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'method': method.toString(),
        });

    final res = await client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch monthly timings: ${res.statusCode}');
    }

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;

    final data = jsonMap['data'] as List<dynamic>;

    return data.map((item) {
      final dataMap = item as Map<String, dynamic>;

      return AladhanTimingsModel.fromJson(
        timingsJson: dataMap['timings'] as Map<String, dynamic>,
        metaJson: dataMap['meta'] as Map<String, dynamic>,
        dateJson: dataMap['date'] as Map<String, dynamic>,
      );
    }).toList();
  }
}
