import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Ramadan/domain/ramadan_reflection.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';

final ayahShareControllerProvider = Provider<AyahShareController>((ref) {
  return AyahShareController(ref);
});

class AyahShareController {
  AyahShareController(this.ref);
  final Ref ref;

  //build ayah text
  String buildText({
    required String arabicText,
    required String englishText,
    required String surahName,
    required int surahId,
    required int ayahNumber,
    required bool includeTranslation,
  }) {
    final refText = '$surahName • $surahId:$ayahNumber';

    final arabic = cleanAyah(arabicText);
    final translation = englishText.trim();

    final buffer = StringBuffer()
      ..writeln(arabic)
      ..writeln()
      ..writeln('— $refText');

    if (includeTranslation && translation.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(translation);
    }

    buffer
      ..writeln()
      ..writeln('Shared from Rafeeq');

    return buffer.toString();
  }

//Build Ramadan reflection text
  String buildRamadanReflectionText({
    required RamadanReflection reflection,
    bool includeLesson = true,
  }) {
    final typeLabel = switch (reflection.type) {
      ReminderType.quran => 'Qur’an',
      ReminderType.hadith => 'Hadith',
      ReminderType.narration => 'Narration',
    };

    final buffer = StringBuffer()
      ..writeln(reflection.topic)
      ..writeln()
      ..writeln(reflection.mainText.trim())
      ..writeln()
      ..writeln(
        '— $typeLabel • ${reflection.sourceLabel} • Day ${reflection.day}',
      );

    if (includeLesson &&
        reflection.lesson != null &&
        reflection.lesson!.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Benefit:')
        ..writeln(reflection.lesson!.trim());
    }

    buffer
      ..writeln()
      ..writeln('Shared from Rafeeq');

    return buffer.toString();
  }

  Future<void> share({
    required BuildContext context,
    required String text,
    String subject = 'Rafeeq',
  }) async {
    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}
