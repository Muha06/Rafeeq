import 'package:rafeeq/features/adhkar/data/datasources/adhkar_local_ds.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';

class AdhkarRepositoryImpl implements AdhkarRepository {
  final AdhkarLocalDataSource localDs;
  const AdhkarRepositoryImpl({required this.localDs});

  //get adhkar
  @override
  Future<List<Dhikr>> getAdhkars(String assetPath) async {
    final models = await localDs.loadAdhkarFromAsset(assetPath);

    //convert to entity
    return models.map((model) => model.toEntity()).toList(growable: false);
  }
}
