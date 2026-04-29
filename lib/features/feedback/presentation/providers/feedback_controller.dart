import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';
import 'package:rafeeq/features/feedback/presentation/providers/wiring_providers.dart';

class FeedbackController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // no initial state needed
  }

  Future<void> send(FeedbackItem feedback) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(feedbackRepositoryProvider);
      await repo.submitFeedback(feedback);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final feedbackControllerProvider =
    AsyncNotifierProvider.autoDispose<FeedbackController, void>(
      FeedbackController.new,
    );
