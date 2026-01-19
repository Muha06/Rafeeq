import 'package:flutter/material.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';

class SurahDetails extends StatelessWidget {
  const SurahDetails({super.key, required this.surah, required this.isDark});

  final Surah surah;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final place = surah.isMeccan ? 'Makkah' : 'Madinah';

    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/quran/surah_details.jpeg',
                fit: BoxFit.cover,
              ),
            ),

            // overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.70),
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.70),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameArabic,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.nameEnglish,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // const Spacer(),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        _Chip(text: '#${surah.id}'),
                        const SizedBox(width: 8),
                        _Chip(text: '$place • ${surah.versesCount} verses'),
                      ],
                    ),
                    // optional: you can add a "Start reading" button row here later
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.95),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
