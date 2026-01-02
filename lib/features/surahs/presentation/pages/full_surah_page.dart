import 'package:flutter/material.dart';

class FullSurahPage extends StatefulWidget {
  const FullSurahPage({
    super.key,
    required this.surahName,
    required this.engName,
  });
  final String surahName;
  final String engName;

  @override
  State<FullSurahPage> createState() => _FullSurahPageState();
}

class _FullSurahPageState extends State<FullSurahPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.surahName, style: theme.appBarTheme.titleTextStyle),
            Text(widget.engName, style: theme.appBarTheme.titleTextStyle),
          ],
        ),
      ),
    );
  }
}
