import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuranAuthClient {
  static const String tokenUrl = 'https://oauth2.quran.foundation/oauth2/token';

  final String clientId;
  final String clientSecret;
  final http.Client httpClient;

  String? _accessToken;
  DateTime? _expiry;

  QuranAuthClient({
    required this.clientId,
    required this.clientSecret,
    required this.httpClient,
  });

  Future<String> getAccessToken() async {
    // refresh a bit early so you don't hit expiry edge-cases
    final now = DateTime.now();
    if (_accessToken != null && _expiry != null && now.isBefore(_expiry!)) {
      return _accessToken!;
    }

    try {
      final basicAuth =
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

      final res = await httpClient.post(
        Uri.parse(tokenUrl),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials', 'scope': 'content'},
      );

      if (res.statusCode != 200) {
        throw Exception(
          'Failed to get access token: ${res.statusCode} ${res.body}',
        );
      }

      final data = json.decode(res.body) as Map<String, dynamic>;
      _accessToken = data['access_token'] as String;

      final expiresIn = (data['expires_in'] as num?)?.toInt() ?? 3600;
      // buffer: subtract 60s to avoid last-second expiry bugs
      _expiry = now.add(Duration(seconds: expiresIn - 60));

      return _accessToken!;
    } catch (e) {
      debugPrint('Error fetching access token');
      rethrow;
    }
  }
}
