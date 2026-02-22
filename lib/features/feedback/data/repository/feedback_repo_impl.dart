import 'package:rafeeq/features/feedback/data/datasource/feedback_ds.dart';
import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';
import 'package:rafeeq/features/feedback/domain/repos/feedback_repo.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitFeedback(FeedbackItem feedback) async {
    await remoteDataSource.submitFeedback(feedback);
  }
}
