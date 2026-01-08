import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/features/Quran/data/models/ayah_dto.dart';
import 'package:rafeeq/features/Quran/data/models/surah_dto.dart';

class QuranApiService {
  static const String baseUrl = 'https://apis.quran.foundation/content/api/v4';
  static const String tokenUrl = 'https://oauth2.quran.foundation/oauth2/token';

  final String clientId;
  final String clientSecret;
  final http.Client? client;

  QuranApiService({
    required this.clientId,
    required this.clientSecret,
    http.Client? client,
  }) : client = client ?? http.Client();

  String? _accessToken;
  DateTime? _expiry;

  /// Step 1: Fetch OAuth2 token
  Future<String> _getAccessToken() async {
    // Already have a token and isnt expired?
    if (_accessToken != null &&
        _expiry != null &&
        DateTime.now().isBefore(_expiry!)) {
      return _accessToken!;
    }

    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

    final response = await client!.post(
      Uri.parse(tokenUrl),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials', 'scope': 'content'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      //accesstoken
      _accessToken = data['access_token'] as String;

      //expiry
      final expiresIn = data['expires_in'] ?? 3600; // usually returned by API
      _expiry = DateTime.now().add(Duration(seconds: expiresIn));
      debugPrint('Got new access token, expires in $expiresIn seconds');

      return _accessToken!;
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }

  /// Step 2: Fetch Surahs
  Future<List<SurahDto>> fetchSurahs() async {
    final token = await _getAccessToken();

    // Add language param to avoid invalid_path
    final url = Uri.parse('$baseUrl/chapters?language=en&limit=114');

    final response = await client!.get(
      url,
      headers: {'x-auth-token': token, 'x-client-id': clientId},
    );

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        final chapters = data['chapters'] as List<dynamic>;
        print('Api fetched successfully: ${chapters.length}');
        
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
  Future<List<AyahDto>> fetchAyahs({
    required int surahId,
    int page = 1,
    int limit = 20,
  }) async {
    final token = await _getAccessToken();

    final url = Uri.parse(
      '$baseUrl/verses/by_chapter/$surahId'
      '?language=en'
      '&translations=20'
      '&fields=text_uthmani'
      '&translation_fields=text'
      '&per_page=286', // max surah length (Baqarah),
    );

    debugPrint(
      'Fetching ayahs for surah: $surahId, page: $page, limit: $limit',
    );

    final response = await client!.get(
      url,
      headers: {'x-auth-token': token, 'x-client-id': clientId},
    );

    if (response.statusCode == 200) {
      // debugPrint('response: ${response.toString()}');

      final data = json.decode(response.body);
      // debugPrint('data: ${data.toString()}');

      final verses = data['verses'] as List<dynamic>;
      debugPrint('verse: ${verses[0]}');
      return verses.map((json) => AyahDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch ayahs: ${response.statusCode} ${response.body}',
      );
    }
  }
}
