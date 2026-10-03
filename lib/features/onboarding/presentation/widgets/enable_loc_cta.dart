import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/presentation/provider/location_prov.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/permission_cta.dart';

class LocationPermissionCta extends ConsumerWidget {
  const LocationPermissionCta({super.key,  });
 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perm = ref.watch(locationPermissionProvider);
    final notifier = ref.read(locationPermissionProvider.notifier);

    // ✅ Already granted
    if (perm.isGranted) {
      return const PermissionCta(
        icon: Icon(Icons.check_circle_rounded, color: Colors.green),
        title: 'Location Enabled',
        subtitle: 'Salah times are based on your location.',
        onTap: null,
      );
    }

    // 🚫 Permanently denied
    if (perm.isPermanentlyDenied) {
      return PermissionCta(
        icon: const Icon(Icons.settings_outlined),
        title: 'Enable Location',
        subtitle: 'Allow location access in Settings for accurate salah times.',
        onTap: perm.isLoading ? null : () => notifier.openSettings(),
      );
    }

    // 🙏 Requestable / not yet asked
    return PermissionCta(
      icon: const Icon(Icons.location_on_outlined),
      title: perm.isLoading ? 'Enabling Location…' : 'Allow Location Access',
      subtitle: 'Get accurate salah times for your location.',
      onTap: perm.isLoading
          ? null
          : () async {
              await notifier.request();
            },
    );
  }
}
