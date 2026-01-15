import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/functions/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarDetailsPage extends ConsumerStatefulWidget {
  const AdhkarDetailsPage({super.key, required this.dhikr});

  final Dhikr dhikr;
  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  void openBottomSheet(Dhikr dhikr) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) {
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //title
              Text('Adhkar settings', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              //divider
              Divider(color: theme.dividerColor),
              const SizedBox(height: 8),

              //copy
              ListTile(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: dhikr.arabic));
                  Navigator.pop(context);
                },
                title: Text('Copy Dhikr', style: theme.textTheme.bodyLarge),
                trailing: const Icon(Icons.copy),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dhikr = widget.dhikr;

    final TextStyle headerStyle = textTheme.bodySmall!.copyWith(fontSize: 14);

    final TextStyle bodyTextstyle = textTheme.bodyMedium!.copyWith(
      color: isDark ? AppDarkColors.textBody : AppLightColors.textBody,
    );

    Widget section(String title, String? text) {
      final t = (text ?? '').trim();
      if (t.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headerStyle), //header
          const SizedBox(height: 8),
          Text(t, style: bodyTextstyle), //text
          const SizedBox(height: 16),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhkār details'),
        bottom: appBarBottomDivider(context),
        actions: [
          IconButton(
            onPressed: () {
              openBottomSheet(dhikr);
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppDarkColors.darkSurface
                  : AppLightColors.lightSurface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  Center(
                    child: Text(
                      dhikr.title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //arabic
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      cleanDhikr(dhikr.arabic),
                      textDirection: TextDirection.rtl,
                      style: textTheme.bodyLarge!.copyWith(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //transliteration
                  section('Transliteration', dhikr.latin),

                  //english
                  section('Translation', dhikr.translation),

                  //note
                  section('Notes', dhikr.notes),

                  //benefit
                  section('Benefit', dhikr.benefits),

                  //fawaid
                  section('Fawaid', dhikr.fawaid),

                  //source
                  if ((dhikr.source ?? '').trim().isNotEmpty) ...[
                    Text('Source:', style: textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(
                      dhikr.source!.trim(),
                      style: textTheme.bodySmall!.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
