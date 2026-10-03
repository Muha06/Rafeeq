import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/app_assets.dart';

class CollectUserNameSlide extends ConsumerWidget {
  const CollectUserNameSlide({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(AppAssets.appIcon, height: 24, width: 24),
                ),
                const SizedBox(width: 6),

                Text('Rafeeq', style: tt.titleSmall?.copyWith(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Assalam alaikum, What should we call you?',
              textAlign: TextAlign.center,
              style: tt.headlineSmall,
            ),
            const SizedBox(height: 16),

            Text(
              'We use this information to personalize your experience and make Rafeeq more useful for you.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium,
            ),

            Expanded(
              child: Center(
                child: IntrinsicWidth(
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    style: tt.titleMedium,
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
