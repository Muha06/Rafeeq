import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/presentation/share/widgets/ayah_share_card.dart';

class AyahShareService {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> shareAyah({
    required BuildContext context,
    required Ayah ayah,
    required String surahName,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;

    final imageBytes = await _screenshotController.captureFromLongWidget(
      InheritedTheme.captureAll(
        context,
        Material(
          color: colorScheme.surface,
          child: Theme(
            data: Theme.of(context),
            child: AyahShareCard(ayah: ayah, surahName: surahName),
          ),
        ),
      ),
      pixelRatio: 2,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width,
        maxHeight: double.infinity,
      ),
    );

    final Directory tempDir = await getTemporaryDirectory();
    final File imageFile = File(
      '${tempDir.path}/rafeeq_ayah_${ayah.surahId}_${ayah.ayahNumber}.png',
    );

    await imageFile.writeAsBytes(imageBytes);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(imageFile.path)], text: 'Shared from Rafeeq'),
    );
  }
}
