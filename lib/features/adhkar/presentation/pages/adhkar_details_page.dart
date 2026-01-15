import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';

class AdhkarDetailsPage extends ConsumerStatefulWidget {
  const AdhkarDetailsPage({super.key});

  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final adhkarAsync = ref.watch(
      getAdhkarsProvider('assets/adhkar/general.json'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhkār'),
        bottom: appBarBottomDivider(context),
      ),
      body: adhkarAsync.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (adhkars) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final dhikr = adhkars[index];

              return ListTile(
                leading: Text(index.toString()),
                title: Text(dhikr.title),
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(color: AppDarkColors.divider),
            itemCount: adhkars.length,
          );
        },
      ),
    );
  }
}
