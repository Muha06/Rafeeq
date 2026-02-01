import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/location/domain/open_mateo.dart';
import 'package:rafeeq/core/location/presentation/provider/open_mateo_provider.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/features/salat-times/presentation/riverpod/salah_times_providers.dart';

enum LocMode { gps, manual }

class UserLocSettingsPage extends ConsumerStatefulWidget {
  const UserLocSettingsPage({super.key});

  @override
  ConsumerState<UserLocSettingsPage> createState() =>
      _UserLocSettingsPageState();
}

class _UserLocSettingsPageState extends ConsumerState<UserLocSettingsPage> {
  LocMode _mode = LocMode.gps;

  String? _country;
  String? _countryCode; // ✅ needed for Open-Meteo country filter
  GeoPlace? _selectedPlace; // ✅ selected from Open-Meteo

  Color get darkSurface => AppDarkColors.darkSurface;

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
      showPhoneCode: false,
      onSelect: (Country c) {
        setState(() {
          _country = c.name;
          _countryCode = c.countryCode; // ✅
          _selectedPlace = null; // reset city
          _mode = LocMode.manual;
          _resetVerification();
        });
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: AppDarkColors.darkSurface,
        textStyle: TextStyle(color: Colors.white.withAlpha(235)),
        inputDecoration: InputDecoration(
          hintText: 'Search country…',
          hintStyle: theme.textTheme.bodySmall,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          fillColor: Colors.white.withAlpha(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withAlpha(26)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withAlpha(26)),
          ),
        ),
      ),
    );
  }

  //PICK CITY
  Future<void> _pickCityViaOpenMeteo() async {
    if (_country == null || _countryCode == null) return;

    final picked = await showModalBottomSheet<GeoPlace>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
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
      final usecase = ref.read(getTodaySalahTimesProvider);
      final method = ref.read(salahMethodProvider);

      // ✅ reliable verification: timings by coordinates
      final times = await usecase.call(
        latitude: p.lat,
        longitude: p.lng,
        city: p.name,
        country: _country ?? p.country,
        method: method,
      );

      debugPrint(times.times.toString());

      setState(() {
        _verified = true;
        _verifiedCity = p.name;
        _verifying = false;
      });
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

    return Scaffold(
      appBar: AppBar(title: const Text('My location')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingCard(
            title: 'Use GPS automatically',
            description:
                'We’ll detect your location and compute prayer times for where you are.',
            selected: _mode == LocMode.gps,
            baseColor: darkSurface,
            selectedColor: AppDarkColors.onDarkSurface,
            onTap: () => setState(() => _mode = LocMode.gps),
            trailing: _mode == LocMode.gps
                ? const Icon(Icons.check_circle_rounded)
                : const Icon(Icons.gps_fixed_rounded),
          ),
          const SizedBox(height: 12),
          _SettingCard(
            title: 'Select country & city manually',
            description:
                'Stable and predictable. No location permission needed.',
            selected: _mode == LocMode.manual,
            baseColor: darkSurface,
            selectedColor: AppDarkColors.onDarkSurface,
            onTap: () => setState(() => _mode = LocMode.manual),
            trailing: _mode == LocMode.manual
                ? const Icon(Icons.expand_less_rounded)
                : const Icon(Icons.expand_more_rounded),
            child: AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    _ActionButton(
                      label: _country == null
                          ? 'Select country'
                          : 'Country: $_country',
                      icon: Icons.public_rounded,
                      onTap: _pickCountry,
                    ),
                    const SizedBox(height: 10),
                    _ActionButton(
                      label: _selectedPlace == null
                          ? 'Select city'
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
                        style: theme.textTheme.bodySmall?.copyWith(),
                      ),
                    ),

                    if (_verifiedCity != null) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Will save: $_country, $_verifiedCity',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: _mode == LocMode.manual
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 180),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
            ),
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
    _debounce = Timer(const Duration(milliseconds: 300), () {
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
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: AppDarkColors.bottomSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(64),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Text(
            'Select city (${widget.countryName})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _ctrl,
            onChanged: _onChanged,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Type city… (e.g. Nai)',
              hintStyle: theme.textTheme.bodyMedium,
              filled: true,
              fillColor: AppDarkColors.onDarkSurface,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withAlpha(26)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withAlpha(26)),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.white.withAlpha(170),
              ),
              suffixIcon: _ctrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withAlpha(200),
                      ),
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
                      Divider(color: Colors.white.withAlpha(15), height: 1),
                  itemBuilder: (_, i) {
                    final p = places[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        p.name,
                        style: TextStyle(color: Colors.white.withAlpha(235)),
                      ),
                      subtitle: Text(
                        p.admin1 == null || p.admin1!.trim().isEmpty
                            ? p.country
                            : '${p.admin1}, ${p.country}',
                        style: TextStyle(color: Colors.white.withAlpha(160)),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withAlpha(120),
                      ),
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

          const SizedBox(height: 6),
          Text(
            'Tip: pick from results (don’t freestyle).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- UI bits ----------

class _SettingCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bg = selected ? selectedColor : baseColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
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
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(184),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                IconTheme(
                  data: IconThemeData(
                    color: Colors.white.withAlpha(selected ? 242 : 166),
                    size: 22,
                  ),
                  child: trailing,
                ),
              ],
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(enabled ? 15 : 8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(enabled ? 26 : 15)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white.withAlpha(217)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(enabled ? 235 : 115),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
