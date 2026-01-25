import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';

abstract class AllahNamesLocalDataSource {
  Future<void> saveAll(List<AllahNameHive> items);
  List<AllahNameHive> getAll();

  Future<void> clear();
}

class AllahNamesLocalDataSourceImpl implements AllahNamesLocalDataSource {
  AllahNamesLocalDataSourceImpl({required this.namesBox});

  final Box<AllahNameHive> namesBox;

  @override
  List<AllahNameHive> getAll() {
    final items = namesBox.values.toList();
    items.sort((a, b) => a.number.compareTo(b.number));
    return items;
  }

  @override
  Future<void> saveAll(List<AllahNameHive> items) async {
    // store by number -> no duplicates + easy overwrite
    final map = {for (final n in items) n.number: n};
    await namesBox.putAll(map);
  }

  @override
  Future<void> clear() async {
    await namesBox.clear();
  }
}
