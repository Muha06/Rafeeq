import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/asma_ul_husna_provider.dart';

final randomAllahNameProvider = Provider.autoDispose<AsyncValue<AllahName>>((
  ref,
) {
  final namesAsync = ref.watch(allahNamesProvider);

  return namesAsync.whenData((names) => names[Random().nextInt(names.length)]);
});
