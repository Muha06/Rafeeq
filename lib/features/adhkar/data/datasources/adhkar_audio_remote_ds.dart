import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DhikrAudioRemoteDataSource {
  Future<String> getMorningUrl();
  Future<String> getEveningUrl();
}

class DhikrAudioRemoteDsImpl implements DhikrAudioRemoteDataSource {
  final SupabaseClient client;
  DhikrAudioRemoteDsImpl(this.client);

  String get _bucket => 'audios';

  @override
  Future<String> getMorningUrl() async {
    return client.storage.from(_bucket).getPublicUrl('morning_adhkar.mp3');
  }

  @override
  Future<String> getEveningUrl() async {
    return client.storage.from(_bucket).getPublicUrl('evening_adhkar.mp3');
  }
}
