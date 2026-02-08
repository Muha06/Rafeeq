import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/core/features/network/quran_auth_client.dart';
import 'package:rafeeq/features/quran/data/models/ayah_dto.dart';
import 'package:rafeeq/features/quran/data/models/surah_dto.dart';

class QuranTextApiService {
  static const String baseUrl = 'https://apis.quran.foundation/content/api/v4';

  final String clientId;
  final QuranAuthClient auth;
  final http.Client client;

  QuranTextApiService({
    required this.clientId,
    required this.auth,
    required this.client,
  });

  Future<Map<String, String>> _authHeaders() async {
    final token = await auth.getAccessToken();
    return {'x-auth-token': token, 'x-client-id': clientId};
  }

  Future<List<SurahDto>> fetchSurahs() async {
    // Add language param to avoid invalid_path
    final url = Uri.parse('$baseUrl/chapters?language=en&limit=114');

    final response = await client.get(url, headers: await _authHeaders());

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final chapters = data['chapters'] as List<dynamic>;

        return chapters.map((json) => SurahDto.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Failed to parse surahs: $e');
      }
    } else {
      throw Exception(
        'Failed to fetch surahs: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Fetch ayahs for a specific surah
  /// Supports pagination with page & limit
  Future<List<AyahDto>> fetchAyahs({required int surahId}) async {
    final url = Uri.parse(
      '$baseUrl/verses/by_chapter/$surahId'
      '?language=en'
      '&translations=20,57' // ✅ English + Transliteration
      '&fields=text_uthmani' // ✅ Arabic
      '&translation_fields=text'
      '&per_page=286',
    );

    final response = await client.get(url, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      debugPrint('data $data', wrapWidth: 2000);

      final verses = data['verses'] as List<dynamic>;
      debugPrint('verses ${verses[1]}', wrapWidth: 2000);
      return verses.map((json) => AyahDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch ayahs: ${response.statusCode} ${response.body}',
      );
    }
  }
}
