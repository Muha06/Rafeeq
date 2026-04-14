import 'package:rafeeq/features/radio_station/data/models/radio_station_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RadioRemoteDataSource {
  final SupabaseClient client;

  RadioRemoteDataSource(this.client);

  /// Fetch all active radio stations
  Future<List<RadioStationModel>> fetchRadioStations() async {
    final response = await client
        .from('radio_stations')
        .select()
        .eq('is_active', true)
        .order('name');

    final data = response as List<dynamic>;

    return data.map((json) => RadioStationModel.fromJson(json)).toList();
  }
}
