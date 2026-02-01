import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/core/location/data/open_mateo_ds.dart';
import 'package:rafeeq/core/location/domain/open_mateo.dart';

/// ----------------------
/// Providers
/// ----------------------
final openMeteoHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final openMeteoGeocodingDsProvider = Provider<OpenMeteoGeocodingDs>((ref) {
  return OpenMeteoGeocodingDs(ref.read(openMeteoHttpClientProvider));
});

typedef GeocodeArgs = ({String query, String countryCode});

final openMeteoCitySearchProvider =
    FutureProvider.family<List<GeoPlace>, GeocodeArgs>((ref, args) async {
      final ds = ref.read(openMeteoGeocodingDsProvider);

      final code = args.countryCode.trim().toUpperCase();
      final q = args.query.trim();
      if (q.isEmpty || code.isEmpty) return const [];

      final results = await ds.search(name: q, countryCode: code);

      return results.where((p) => p.countryCode.toUpperCase() == code).toList();
    });
