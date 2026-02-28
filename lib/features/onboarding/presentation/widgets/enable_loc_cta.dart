import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/onboarding/presentation/provider/location_prov.dart';

class LocationPermissionCta extends ConsumerStatefulWidget {
  const LocationPermissionCta({super.key});

  /// Optional: if you want, auto-advance PageView when granted

  @override
  ConsumerState<LocationPermissionCta> createState() =>
      _LocationPermissionCtaState();
}

class _LocationPermissionCtaState extends ConsumerState<LocationPermissionCta> {
  @override
  Widget build(BuildContext context) {
    final perm = ref.watch(locationPermissionProvider);
    final notifier = ref.read(locationPermissionProvider.notifier);

    // ✅ Already granted
    if (perm.isGranted) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('Location Enabled'),
      );
    }

    // 🚫 Permanently denied
    if (perm.isPermanentlyDenied) {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              notifier.openSettings();
            },
            icon: const Icon(Icons.settings_rounded),
            label: const Text('Open Settings'),
          ),
          const SizedBox(height: 8),
          Text(
            'Enable location in Settings for accurate prayer times.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withAlpha(120)),
          ),
        ],
      );
    }

    // 🙏 Requestable denied
    return ElevatedButton.icon(
      onPressed: perm.isLoading
          ? null
          : () async {
              await notifier.request();
            },
      icon: perm.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.location_on_rounded),
      label: Text(perm.isLoading ? 'Enabling…' : 'Enable Location'),
    );
  }
}
