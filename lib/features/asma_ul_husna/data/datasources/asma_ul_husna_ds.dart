import 'package:dio/dio.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/name_model.dart';

abstract class AllahNamesRemoteDataSource {
  Future<List<AllahNameDto>> fetchAllahNames();
}

class AllahNamesRemoteDataSourceImpl implements AllahNamesRemoteDataSource {
  final Dio dio;

  AllahNamesRemoteDataSourceImpl(this.dio);

  static const _endpoint = 'https://api.aladhan.com/v1/asmaAlHusna';

  @override
  Future<List<AllahNameDto>> fetchAllahNames() async {
    final res = await dio.get(_endpoint);

    final body = res.data;
    if (body is! Map) return const [];

    final data = body['data']; //data
    
    if (data is! List) return const [];

    return data
        .whereType<Map>()
        .map((e) => AllahNameDto.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
