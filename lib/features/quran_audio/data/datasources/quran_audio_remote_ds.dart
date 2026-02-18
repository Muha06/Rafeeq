import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rafeeq/core/features/network/quran_auth_client.dart';
import 'package:rafeeq/features/quran_audio/data/models/audio_file_dto.dart';
import 'package:rafeeq/features/quran_audio/data/models/chapter_file_response.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';

class QuranAudioApiService {
  static const String baseUrl = 'https://apis.quran.foundation/content/api/v4';

  final String clientId;
  final QuranAuthClient auth;
  final http.Client client;

  QuranAudioApiService({
    required this.clientId,
    required this.auth,
    required this.client,
  });

  Future<Map<String, String>> _authHeaders() async {
    final token = await auth.getAccessToken();
    return {'x-auth-token': token, 'x-client-id': clientId};
  }

  //Fetch audio for a surah
  Future<AudioFileDto> fetchChapterAudioFile({
    required int reciterId,
    required int chapterNumber,
  }) async {
    final url = Uri.parse(
      '$baseUrl/chapter_recitations/$reciterId/$chapterNumber',
    );

    final response = await client.get(url, headers: await _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch chapter audio: ${response.statusCode} ${response.body}',
      );
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final dto = ChapterRecitationResponseDto.fromJson(data);
    final AudioFileDto audioFile = dto.audioFile;

    if (audioFile.audioUrl.trim().isEmpty) {
      throw Exception('Audio URL missing in audio_file.audio_url');
    }

    if (audioFile.chapterId != chapterNumber) {
      throw Exception(
        'Chapter mismatch. Requested=$chapterNumber, got=${audioFile.chapterId}',
      );
    }
    return audioFile;
  }

  // Fetch all reciters
  Future<List<ReciterLite>> fetchChapterRecitersLite({
    String language = 'en',
    int? limit, // optional, some APIs support it
  }) async {
    final url = Uri.parse(
      '$baseUrl/resources/chapter_reciters?language=$language',
    );
    final res = await client.get(url, headers: await _authHeaders());

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to fetch reciters: ${res.statusCode} ${res.body}',
      );
    }

    final data = json.decode(res.body) as Map<String, dynamic>;

    // API usually returns: { "reciters": [ ... ] }
    final list = (data['reciters'] as List<dynamic>?);
    if (list == null) {
      throw Exception('Unexpected response shape. Top keys: ${data.keys}');
    }

    return list.map((e) {
      final m = e as Map<String, dynamic>;
      final id = m['id'] as int;
      final name =
          (m['name'] as String?) ??
          (m['translated_name']?['name'] as String?) ??
          'Unknown';
      return ReciterLite(id: id, name: name);
    }).toList();
  }
}
