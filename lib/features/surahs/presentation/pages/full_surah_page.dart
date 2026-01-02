import 'package:flutter/material.dart';

class FullSurahPage extends StatefulWidget {
  const FullSurahPage({super.key, required this.surahName});
  final String surahName;

  @override
  State<FullSurahPage> createState() => _FullSurahPageState();
}

class _FullSurahPageState extends State<FullSurahPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName, style: theme.appBarTheme.titleTextStyle),
      ),
    );
  }
}
