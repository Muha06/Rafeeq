import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/home/presentation/widgets/user_location_chip.dart';
import 'package:rafeeq/features/qibla/presentation/widgets/qibla_compass.dart';
import 'package:rafeeq/features/qibla/presentation/widgets/qibla_instruction_sheet.dart';

class QiblaPage extends ConsumerStatefulWidget {
  const QiblaPage({super.key});

  @override
  ConsumerState<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends ConsumerState<QiblaPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      QiblaInstructionSheet.show(context);

      RafeeqAnalytics.logFeature('Qibla_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Qibla')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: UserLocationChip(fgColor: cs.onSurface),
              ),

              const SizedBox(height: 24),

              Image.asset(
                "assets/images/qibla/kaaba.png",
                height: 52,
                width: 52,
              ),

              const SizedBox(height: 48),

              const QiblaCompass(),
            ],
          ),
        ),
      ),
    );
  }
}
