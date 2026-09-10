import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_page.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/random_name_provider.dart';

class AsmaulHusnaHomeCard extends ConsumerWidget {
  const AsmaulHusnaHomeCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final randomAllahNameState = ref.watch(dailyAllahNameProvider);

    final fgColor = cs.onSurface;

    return randomAllahNameState.when(
      error: (error, _) => Text(error.toString()),
      loading: () => const SizedBox.shrink(),
      data: (name) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () => AppNav.push(context, const AllahNamesPage()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(HugeIconsStroke.allah, size: 20, color: fgColor),
                  const SizedBox(width: 8),
                  Text(
                    'Asmaul Husna',
                    style: theme.textTheme.labelLarge?.copyWith(color: fgColor),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  name.arabic,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.arabicUi.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  name.transliteration,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: fgColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Center(
                child: Text(
                  name.translations[AllahNameLanguage.english]!.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
