import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';

abstract class FeedbackRepository {
  Future<void> submitFeedback(FeedbackItem feedback);
}
