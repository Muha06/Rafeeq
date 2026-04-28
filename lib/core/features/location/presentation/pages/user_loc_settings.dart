import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/domain/open_mateo.dart';
import 'package:rafeeq/core/features/location/presentation/provider/open_mateo_provider.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_times_providers.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserLocSettingsPage extends ConsumerStatefulWidget {
  const UserLocSettingsPage({super.key});

  @override
  ConsumerState<UserLocSettingsPage> createState() =>
      _UserLocSettingsPageState();
}

class _UserLocSettingsPageState extends ConsumerState<UserLocSettingsPage> {
  bool _manualExpanded = false;

  String? _country;
  String? _countryCode; // ✅ needed for Open-Meteo country filter
  GeoPlace? _selectedPlace; // ✅ selected from Open-Meteo

  bool _verifying = false;
  String? _verifyError;
  bool _verified = false;

  String? _verifiedCity;

  void _resetVerification() {
    _verifyError = null;
    _verified = false;
    _verifiedCity = null;
  }

  //PICK COUNTRY
  Future<void> _pickCountry() async {
    final theme = Theme.of(context);

    showCountryPicker(
      context: context,
      onSelect: (Country c) {
        setState(() {
          _country = c.name;
          _countryCode = c.countryCode; // ✅
          _selectedPlace = null; // reset city
          _resetVerification();
        });
      },
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
        backgroundColor: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        textStyle: theme.textTheme.bodyMedium,
        inputDecoration: InputDecoration(
          hintText: 'Search country…',
          prefixIcon: Icon(PhosphorIcons.magnifyingGlass()),
        ),
      ),
    );
  }

  //PICK CITY
  Future<void> _pickCityViaOpenMeteo() async {
    if (_country == null || _countryCode == null) return;

    final picked = await showModalBottomSheet<GeoPlace>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (_) =>
          CitySearchSheet(countryName: _country!, countryCode: _countryCode!),
    );

    if (picked == null) return;

    setState(() {
      _selectedPlace = picked;
      _resetVerification();
    });

    await _verifyByCoords(picked);
  }

  Future<void> _verifyByCoords(GeoPlace p) async {
    setState(() {
      _verifying = true;
      _verifyError = null;
      _verified = false;
      _verifiedCity = null;
    });

    try {
      final usecase = ref.read(fetchSalahTimesUsecase);
      final method = ref.read(salahMethodProvider);

      await usecase.call(
        latitude: p.lat,
        longitude: p.lng,
        city: p.name,
        country: _country ?? p.country,
        method: method,
      );

      setState(() {
        _verified = true;
        _verifiedCity = p.name;
        _verifying = false;
      });

      //After verifying -> setManual
      await ref
          .read(userLocationProvider.notifier)
          .setManual(
            lat: p.lat,
            lng: p.lng,
            city: p.name,
            country: _country ?? p.country,
          );
      setState(() => _manualExpanded = true);

      ref.invalidate(todaySalahTimesProvider);
      RafeeqAnalytics.logFeature("location_set_manual");
    } catch (e) {
      setState(() {
        _verifyError = 'Couldn’t verify timings. Try another city.';
        _verifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isAuto = ref
        .watch(userLocationProvider)
        .maybeWhen(data: (loc) => loc?.isAuto ?? true, orElse: () => true);

    final userLocState = ref.watch(userLocationProvider).value;

    final notifier = ref.read(userLocationProvider.notifier);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My location')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingCard(
            title: 'Use GPS automatically',
            description:
                'We’ll detect your location and compute prayer times for where you are.',
            selected: isAuto,
            selectedColor: cs.surfaceContainerHighest,
            baseColor: cs.surface,
            onTap: () async {
              if (isAuto) return;

              setState(() {
                _manualExpanded = false;
                _country = null;
                _countryCode = null;
                _selectedPlace = null;
                _verifiedCity = null;
              });

              AppSnackBar.showSimple(
                context: context,
                duration: const Duration(seconds: 3),
                message: 'Setting to GPS mode...',
              );

              //Save as auto
              await notifier.setAuto();
              ref.invalidate(todaySalahTimesProvider);

              RafeeqAnalytics.logFeature("location_set_auto");
            },
            trailing: isAuto
                ? const Icon(Icons.check_circle_rounded)
                : const Icon(Icons.gps_fixed_rounded),
          ),
          const SizedBox(height: 12),

          //MANUAL
          _SettingCard(
            title: 'Select country & city manually',
            description:
                'Stable and predictable. No location permission needed.',
            selected: !isAuto,
            selectedColor: cs.surfaceContainerHighest,
            baseColor: cs.surface,
            onTap: () {
              setState(() => _manualExpanded = !_manualExpanded);
            },
            trailing: _manualExpanded
                ? const Icon(Icons.expand_less_rounded)
                : const Icon(Icons.expand_more_rounded),
            child: _manualExpanded
                ? AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          _ActionButton(
                            label: _country == null
                                ? !isAuto
                                      ? userLocState?.country ??
                                            'Select country'
                                      : 'Select country'
                                : 'Country: $_country',
                            icon: Icons.public_rounded,
                            onTap: _pickCountry,
                          ),
                          const SizedBox(height: 10),
                          _ActionButton(
                            label: _selectedPlace == null
                                ? !isAuto
                                      ? userLocState?.city ?? 'Select city'
                                      : 'Select city'
                                : 'City: ${_selectedPlace!.name}',
                            icon: Icons.location_city_rounded,
                            onTap: _countryCode == null
                                ? null
                                : _pickCityViaOpenMeteo,
                          ),

                          if (_verifying) ...[
                            const SizedBox(height: 10),
                            const LinearProgressIndicator(),
                          ],

                          if (_verifyError != null) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _verifyError!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.redAccent.withAlpha(220),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _country == null
                                  ? 'Pick a country to continue.'
                                  : (_selectedPlace == null
                                        ? 'Now pick a city.'
                                        : (_verified
                                              ? 'City verified ✓,  '
                                              : 'Verifying…')),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),

                          if (_verifiedCity != null) ...[
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Will save: ${_country ?? _selectedPlace?.country}, $_verifiedCity',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    crossFadeState: _manualExpanded || !isAuto
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 180),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeOut,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

//city search modal sheet
class CitySearchSheet extends ConsumerStatefulWidget {
  const CitySearchSheet({
    super.key,
    required this.countryName,
    required this.countryCode,
  });

  final String countryName;
  final String countryCode;

  @override
  ConsumerState<CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends ConsumerState<CitySearchSheet> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  String _q = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      setState(() => _q = v.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final asyncPlaces = (_q.isEmpty)
        ? const AsyncValue<List<GeoPlace>>.data([])
        : ref.watch(
            openMeteoCitySearchProvider((
              query: _q,
              countryCode: widget.countryCode,
            )),
          );

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select city (${widget.countryName})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _ctrl,
            onChanged: _onChanged,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Type city… (e.g. Nai)',
              hintStyle: theme.textTheme.bodySmall,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _ctrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _ctrl.clear();
                        setState(() => _q = '');
                      },
                    ),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: asyncPlaces.when(
              data: (places) {
                if (_q.isEmpty) {
                  return Center(
                    child: Text(
                      'Start typing to search cities.',
                      style: TextStyle(color: Colors.white.withAlpha(170)),
                    ),
                  );
                }
                if (places.isEmpty) {
                  return Center(
                    child: Text(
                      'No results. Try different spelling.',
                      style: TextStyle(color: Colors.white.withAlpha(170)),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: places.length,
                  separatorBuilder: (_, _) =>
                      Divider(color: theme.dividerColor, height: 1),
                  itemBuilder: (_, i) {
                    final p = places[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(p.name, style: theme.textTheme.labelLarge),
                      subtitle: Text(
                        p.admin1 == null || p.admin1!.trim().isEmpty
                            ? p.country
                            : '${p.admin1}, ${p.country}',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.pop(context, p),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'City search failed. Check internet and try again.',
                  style: TextStyle(color: Colors.redAccent.withAlpha(220)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- UI bits ----------
class _SettingCard extends ConsumerWidget {
  const _SettingCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.baseColor,
    required this.selectedColor,
    required this.onTap,
    required this.trailing,
    this.child,
  });

  final String title;
  final String description;
  final bool selected;
  final Color baseColor;
  final Color selectedColor;
  final VoidCallback onTap;
  final Widget trailing;
  final Widget? child;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? selectedColor : baseColor,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: tt.labelLarge),
                      const SizedBox(height: 6),
                      Text(description, style: tt.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                trailing,
              ],
            ),
            if (child != null) ...[child!],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends ConsumerWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, ref) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.onSurfaceVariant.withAlpha(64)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
