import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhkars'),
        bottom: appBarBottomDivider(context),
      ),
      body: adhkars.when(
        error: (error, stackTrace) => const Center(child: Text('Error')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (adhkars) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                const Divider(color: AppDarkColors.divider),
            itemCount: adhkars.length,
            itemBuilder: (context, index) {
              final dhikr = adhkars[index];

              return AdhkarListTile(dhikr: dhikr, index: index);
            },
          );
        },
      ),
    );
  }
}

class AdhkarListTile extends StatelessWidget {
  const AdhkarListTile({super.key, required this.dhikr, required this.index});

  final Dhikr dhikr;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
      child: SizedBox(
        // height: 48,
        child: Row(
          children: [
            Container(
              height: 24,
              width: 36,
              decoration: BoxDecoration(
                color: AppDarkColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: AppDarkColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                dhikr.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              CupertinoIcons.right_chevron,
              size: 18,
              color: AppDarkColors.iconSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
