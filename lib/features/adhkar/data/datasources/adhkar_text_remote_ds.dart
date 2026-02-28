import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rafeeq/features/adhkar/data/models/dhikr_model.dart';

abstract class DhikrTextRemoteDataSource {
  /// Fetch dhikr for a single category id
  Future<List<DhikrModel>> fetchSubcategoryById(int categoryId);
}

class DhikrTextRemoteDataSourceImpl implements DhikrTextRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  DhikrTextRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://www.hisnmuslim.com/api/en/',
  });

  //returns subcategory and list of adhkars
  @override
  Future<List<DhikrModel>> fetchSubcategoryById(int categoryId) async {
    final url = Uri.parse('$baseUrl$categoryId.json');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch dhikr for category $categoryId');
    }

    final Map<String, dynamic> data = json.decode(response.body);

    final categoryTitle = data.keys.first;

    // The API returns an object with category title as key and list of dhikr as value
    final dhikrListJson = data.values.first as List<dynamic>;

    return dhikrListJson
        .map(
          (json) =>
              DhikrModel.fromJson(json: json, categoryTitle: categoryTitle),
        )
        .toList();
  }
}
