import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';

void main() {
  late http.Client client;
  late SalahRemoteDataSource ds;

  setUp(() {
    client = http.Client();
    ds = SalahRemoteDataSourceImpl(client);
  });

  tearDown(() {
    client.close();
  });

  group('SalahRemoteDataSource', () {
    test('should fetch monthly salah timings from AlAdhan API', () async {
      // ACT
      final result = await ds.fetchMonthByCity(
        city: 'Nairobi',
        country: 'Kenya',
        method: 3,
      );

      debugPrint("Result: ${result.length} timings fetched for the month.");

      // ASSERT
      expect(result, isNotEmpty);
      expect(result.length, greaterThanOrEqualTo(28));

      expect(result.first.fajr, isNotEmpty);
      expect(result.first.sunrise, isNotEmpty);
      expect(result.first.dhuhr, isNotEmpty);
      expect(result.first.asr, isNotEmpty);
      expect(result.first.maghrib, isNotEmpty);
      expect(result.first.isha, isNotEmpty);
    });
  });
}
