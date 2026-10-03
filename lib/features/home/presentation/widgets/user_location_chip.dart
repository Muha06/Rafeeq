import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/location/presentation/pages/user_loc_settings.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';

class UserLocationChip extends ConsumerWidget {
  const UserLocationChip({super.key, this.padding, required this.fgColor});

  final EdgeInsets? padding;
  final Color fgColor;

  @override
  Widget build(BuildContext context, ref) {
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      error: (error, stackTrace) => _MyUserLocChip(
        icon: Icons.error_outline,
        label: 'retry',
        padding: padding,
        fgColor: fgColor,
        onTap: () => ref.read(userLocationProvider.notifier).refresh(),
      ),
      loading: () => const SizedBox.shrink(),
      data: (userLocation) => _MyUserLocChip(
        icon: PhosphorIcons.mapPin,
        label: userLocation.city,
        padding: padding,
        fgColor: fgColor,
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
    required this.fgColor,
    this.padding,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: fgColor.withAlpha(160)),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: fgColor),
              const SizedBox(width: 4),

              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: fgColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
