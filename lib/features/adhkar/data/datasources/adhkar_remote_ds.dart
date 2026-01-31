import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AdhkarRemoteDataSource {
  Future<String> getMorningUrl();
  Future<String> getEveningUrl();
}

class AdhkarRemoteDsImpl implements AdhkarRemoteDataSource {
  final SupabaseClient client;
  AdhkarRemoteDsImpl(this.client);

  String get _bucket => dotenv.env['SUPABASE_AUDIO_BUCKET'] ?? 'audios';

  @override
  Future<String> getMorningUrl() async {
    return client.storage.from(_bucket).getPublicUrl('morning_adhkar.mp3');
  }

  @override
  Future<String> getEveningUrl() async {
    return client.storage.from(_bucket).getPublicUrl('evening_adhkar.mp3');
  }
}
