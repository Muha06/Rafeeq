import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/feedback/data/datasource/feedback_ds.dart';
import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';
import 'package:rafeeq/features/feedback/data/repository/feedback_repo_impl.dart';
import 'package:rafeeq/features/feedback/domain/repos/feedback_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final feedbackRemoteDataSourceProvider = Provider<FeedbackRemoteDataSource>((
  ref,
) {
  final client = Supabase.instance.client;
  return FeedbackRemoteDataSourceImpl(client);
});

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final remote = ref.watch(feedbackRemoteDataSourceProvider);
  return FeedbackRepositoryImpl(remote);
});

final sendFeedbackProvider = FutureProvider.family<void, FeedbackItem>((
  ref,
  feedback,
) async {
  final repo = ref.read(feedbackRepositoryProvider);
  await repo.submitFeedback(feedback);
});
