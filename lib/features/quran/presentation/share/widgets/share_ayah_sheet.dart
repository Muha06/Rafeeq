import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';

enum AyahShareType { image, text }

Future<AyahShareType?> showAyahShareSheet(BuildContext context) {
  final theme = Theme.of(context);

  return AppSheets.showBottomSheet(
    context: context,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Share ayah', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),

            Text(
              'Choose how you want to share this ayah.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            _ShareOptionTile(
              icon: Icons.image_outlined,
              title: 'Share as image',
              subtitle: 'A beautiful image with Rafeeq branding',
              onTap: () => Navigator.pop(context, AyahShareType.image),
            ),

            const SizedBox(height: 12),

            _ShareOptionTile(
              icon: Icons.text_fields_rounded,
              title: 'Share as text',
              subtitle: 'Share the Arabic ayah and translation',
              onTap: () => Navigator.pop(context, AyahShareType.text),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ShareOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
