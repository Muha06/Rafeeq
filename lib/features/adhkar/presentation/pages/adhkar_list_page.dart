import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarListPage extends ConsumerStatefulWidget {
  const AdhkarListPage({super.key, required this.category});
  final AdhkarCategory category;

  @override
  ConsumerState<AdhkarListPage> createState() => _AdhkarListPageState();
}

class _AdhkarListPageState extends ConsumerState<AdhkarListPage> {
  @override
  Widget build(BuildContext context) {
    final assetPath = widget.category.assetPath;
    final adhkars = ref.watch(getAdhkarsProvider(assetPath));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        bottom: appBarBottomDivider(context),
      ),
      body: adhkars.when(
        error: (error, stackTrace) => const Center(child: Text('Error')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (adhkars) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: theme.dividerColor),
            itemCount: adhkars.length,
            itemBuilder: (context, index) {
              final dhikr = adhkars[index];

              return AdhkarListTile(
                dhikr: dhikr,
                index: index,
                adhkars: adhkars,
              );
            },
          );
        },
      ),
    );
  }
}

class AdhkarListTile extends ConsumerWidget {
  const AdhkarListTile({
    super.key,
    required this.dhikr,
    required this.index,
    required this.adhkars,
  });

  final Dhikr dhikr;
  final List<Dhikr> adhkars;
  final int index;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdhkarDetailsPage(
              dhikr: dhikr,
              adhkars: adhkars,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
        child: SizedBox(
          // height: 48,
          child: Row(
            children: [
              Container(
                height: 24,
                width: 36,
                decoration: BoxDecoration(
                  color: isDark ? AppDarkColors.amber : AppDarkColors.amberSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: isDark
                          ? AppDarkColors.darkBackground
                          : AppLightColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  dhikr.title.trim(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 16,
                    color: isDark
                        ? AppDarkColors.textPrimary
                        : AppLightColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.right_chevron,
                size: 18,
                color: isDark
                    ? AppDarkColors.iconSecondary
                    : AppLightColors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
