import 'package:dio/dio.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_auth_client.dart';
import 'package:rafeeq/features/quran_audio/data/models/audio_file_dto.dart';

class QuranAudioApiService {
  static const String baseUrl = 'https://apis.quran.foundation/content/api/v4';

  final String clientId;
  final QuranAuthClient auth;
  final Dio dio;
  QuranAudioApiService({
    required this.clientId,
    required this.auth,
    required this.dio,
  });

  // Fetch list of chapter recitations of a surah
  Future<List<AudioFileDto>> fetchReciterPlaylist(int reciterId) async {
    final response = await dio.get(
      '$baseUrl/chapter_recitations/$reciterId',
      options: Options(headers: await _authHeaders()),
    );

    final data = response.data as Map<String, dynamic>;

    final audioFiles = data['audio_files'] as List<dynamic>;

    return audioFiles
        .map((json) => AudioFileDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await auth.getAccessToken();
    return {'x-auth-token': token, 'x-client-id': clientId};
  }
}
