import 'package:flutter/material.dart';

PreferredSizeWidget appBarBottomDivider(BuildContext context) {
  final theme = Theme.of(context);

  return PreferredSize(
    preferredSize: const Size.fromHeight(1),
    child: Divider(
      height: 1,
      thickness: 1,
      color: theme.dividerColor.withAlpha(20),
    ),
  );
}
