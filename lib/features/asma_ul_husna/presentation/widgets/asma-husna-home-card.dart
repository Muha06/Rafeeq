import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_page.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/random_name_provider.dart';

class AsmaulHusnaHomeCard extends ConsumerWidget {
  const AsmaulHusnaHomeCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final randomAllahNameState = ref.watch(randomAllahNameProvider);

    final fgColor = cs.onSurface;

    return randomAllahNameState.when(
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      data: (name) =>
          Container(
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
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 20,
                            color: fgColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Asmaul Husna',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: fgColor,
                            ),
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
                          name.meaningEn,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(
                begin: 0.05,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
