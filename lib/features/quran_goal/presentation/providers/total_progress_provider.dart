import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';

//
final totalQuranProgressProvider = Provider<Progress>((ref) {
  return ref.watch(progressProvider);
});
