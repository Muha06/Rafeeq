import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/location/presentation/pages/user_loc_settings.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';

class UserLocationChip extends ConsumerWidget {
  const UserLocationChip({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      error: (error, stackTrace) => _MyUserLocChip(
        icon: Icons.error_outline,
        label: 'retry',
        onTap: () => ref.read(userLocationProvider.notifier).refresh(),
      ),
      loading: () => const SizedBox.shrink(),
      data: (userLocation) => _MyUserLocChip(
        icon: PhosphorIcons.mapPin,
        label: userLocation.city,
        onTap: () => AppNav.push(context, const UserLocSettingsPage()),
      ),
    );
  }
}

class _MyUserLocChip extends StatelessWidget {
  const _MyUserLocChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        color: WidgetStatePropertyAll(cs.surfaceContainerHighest),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        label: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: cs.onSurface),
                const SizedBox(width: 4),

                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
