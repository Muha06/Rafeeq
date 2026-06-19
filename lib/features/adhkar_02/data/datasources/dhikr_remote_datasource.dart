import 'package:flutter/material.dart';
import 'package:rafeeq/features/adhkar_02/data/models/dhikr_category_dto.dart';
import 'package:rafeeq/features/adhkar_02/data/models/dhikr_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AdhkarRemoteDataSource {
  Future<List<DhikrCategoryDto>> fetchAllCategories();
  Future<List<DhikrDto>> fetchAllDhikrs(String subcategoryId);
}

class AdhkarRemoteDatasourceImpl implements AdhkarRemoteDataSource {
  final SupabaseClient client;
  AdhkarRemoteDatasourceImpl({required this.client});

  @override
  Future<List<DhikrCategoryDto>> fetchAllCategories() async {
    try {
      final response = await client
          .from('adhkar_categories')
          .select()
          .order('sort_order', ascending: true);

      debugPrint('response: $response');

      return response.map((json) => DhikrCategoryDto.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      rethrow;
    }
  }

  @override
  Future<List<DhikrDto>> fetchAllDhikrs(String categoryId) async {
    try {
      final response = await client
          .from('adhkar')
          .select()
          .eq('category_id', categoryId)
          .order('sort_order', ascending: true);

      debugPrint('response: $response');

      return response.map((json) => DhikrDto.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching adhkars: $e');
      rethrow;
    }
  }
}
