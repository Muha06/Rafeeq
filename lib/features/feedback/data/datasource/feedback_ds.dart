import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
abstract class FeedbackRemoteDataSource {
  Future<void> submitFeedback(FeedbackItem feedback);
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final SupabaseClient client;

  FeedbackRemoteDataSourceImpl(this.client);

  @override
  Future<void> submitFeedback(FeedbackItem feedback) async {
    await client.from('feedback').insert(feedback.toMap());
  }
}
