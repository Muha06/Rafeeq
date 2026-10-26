import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_page.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/random_name_provider.dart';

class AsmaulHusnaHomeCard extends ConsumerWidget {
  const AsmaulHusnaHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final randomAllahNameState = ref.watch(dailyAllahNameProvider);

    return randomAllahNameState.when(
      error: (error, _) => Text(error.toString()),
      loading: () => const SizedBox.shrink(),
      data: (name) => AppPressableScale(
        scale: 0.97,
        onTap: () =>
            AppNav.push(context, AllahNamesPage(autoScrollName: name.number)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: label, transliteration, meaning
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ASMAUL HUSNA',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    name.transliteration,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    name.translations[AllahNameLanguage.english]!.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right: large gold Arabic name
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  name.arabic,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.arabicUi.copyWith(
                    color: cs.tertiary,
                    fontSize: 38,
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
