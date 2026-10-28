import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rafeeq/core/constants/app_assets.dart';
import 'package:rafeeq/core/helpers/app_review_service.dart';
import 'package:rafeeq/features/settings/presentation/share/widgets/share_app_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class AppShareService {
  final ScreenshotController _screenshotController = ScreenshotController();
  final AppReviewService _reviewService = const AppReviewService();

  Future<void> shareApp({required BuildContext context}) async {
    final theme = Theme.of(context);

    // Make sure the icon is decoded before capture, or it can render blank
    await precacheImage(const AssetImage(AppAssets.appIcon), context);
    if (!context.mounted) return;

    final imageBytes = await _screenshotController.captureFromLongWidget(
      InheritedTheme.captureAll(
        context,
        Material(
          color: theme.colorScheme.surface,
          child: Theme(data: theme, child: const AppShareCard()),
        ),
      ),
      pixelRatio: 3,
      constraints: const BoxConstraints(
        minWidth: AppShareCard.width,
        maxWidth: AppShareCard.width,
        maxHeight: double.infinity,
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/rafeeq_share.png');
    await file.writeAsBytes(imageBytes);

    const caption =
        "I've been using *Rafeeq*, an Islamic companion app for the Qur'an, salah times, adhkār and Qibla, all in one place.\n\n"
        "It's completely *free*, with *no ads* and no subscriptions. You might find it beneficial too, in shaa Allah 🤍\n\n"
        "Download on Google Play:\n"
        "https://play.google.com/store/apps/details?id=com.mohaa.rafeeq";

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: caption),
    );

    _reviewService.requestReview();
  }
}
