import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/share/widgets/allah_name_share_card.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class AllahNameShareService {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> shareAllahName({
    required AllahName name,
    required BuildContext context,
  }) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageBytes = await _screenshotController.captureFromWidget(
      InheritedTheme.captureAll(
        context,
        Material(
          color: colorScheme.surface,
          child: Theme(
            data: theme,
            child: AllahNameShareCard(name: name),
          ),
        ),
      ),
      pixelRatio: 2,
      targetSize: const Size(540, 720),
    );

    final tempDir = await getTemporaryDirectory();

    final imageFile = File(
      '${tempDir.path}/rafeeq_Allah_name_'
      '${name.number}_${DateTime.now().microsecondsSinceEpoch}.png',
    );

    await imageFile.writeAsBytes(imageBytes, flush: true);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(imageFile.path)], text: 'Shared from Rafeeq'),
    );
  }
}
