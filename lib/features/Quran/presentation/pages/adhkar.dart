import 'package:flutter/material.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';

class AdhkarPage extends StatefulWidget {
  const AdhkarPage({super.key});

  @override
  State<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends State<AdhkarPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhkār'),
        bottom: appBarBottomDivider(context),
      ),
    );
  }
}
