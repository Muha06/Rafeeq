import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppReviewService {
  const AppReviewService();

  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      debugPrint("Requesting app review");

      inAppReview.requestReview();
    }
  }
}

final appReviewServiceProvider = Provider<AppReviewService>((ref) {
  return const AppReviewService();
});
