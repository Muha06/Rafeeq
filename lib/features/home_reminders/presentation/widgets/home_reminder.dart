import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class HomeReminderCard extends StatelessWidget {
  const HomeReminderCard({super.key, required this.title, required this.onTap});

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary,
                  Color.lerp(cs.primary, cs.tertiary, 0.55) ?? cs.primary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -18,
                  top: -24,
                  child: Icon(
                    PhosphorIcons.moonThin,
                    size: 92,
                    color: cs.onPrimary.withValues(alpha: 0.08),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: cs.onPrimary.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            CupertinoIcons.bell,
                            color: cs.onPrimary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'PlayFairDisplay',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          PhosphorIcons.arrowUpRight,
                          color: cs.onPrimary.withValues(alpha: 0.86),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
