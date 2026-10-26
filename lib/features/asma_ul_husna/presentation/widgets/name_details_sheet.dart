import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/share/services/name_share_service.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/widgets/allah_name_tile.dart';

class AllahNameDetailsSheet extends ConsumerWidget {
  final AllahName name;

  const AllahNameDetailsSheet({super.key, required this.name});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    final translation = name.translations[AllahNameLanguage.english];

    if (translation == null) {
      return const SizedBox.shrink();
    }

    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 0.3,
      expand: false,
      builder: (_, scrollController) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 48, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Arabic
                  Text(
                    name.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.arabicUi.copyWith(
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    translation.name,
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      name.transliteration,
                      style: tt.titleMedium?.copyWith(
                        fontFamily: AppStrings.displayFont,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlayAllahNameButton(name: name),

                      const SizedBox(width: 16),

                      AppPressableScale(
                        scale: 0.8,
                        onTap: () {
                          AllahNameShareService().shareAllahName(
                            name: name,
                            context: context,
                          );
                        },
                        child: AppIconContainer(
                          backgroundColor: cs.surfaceContainerHigh,
                          borderRadius: 999,
                          size: 48,
                          child: Icon(
                            HugeIconsSolid.share01,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Meaning', style: tt.labelMedium),
                  ),

                  const SizedBox(height: 8),

                  Text(translation.meaning, style: tt.bodyLarge),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Details', style: tt.labelMedium),
                  ),

                  const SizedBox(height: 8),

                  MarkdownBody(
                    data: translation.details,
                    styleSheet: MarkdownStyleSheet(
                      p: tt.bodyLarge,
                      strong: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
