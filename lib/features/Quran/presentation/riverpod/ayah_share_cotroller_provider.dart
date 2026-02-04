import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';

final ayahShareControllerProvider = Provider<AyahShareController>((ref) {
  return AyahShareController(ref);
});

class AyahShareController {
  AyahShareController(this.ref);
  final Ref ref;

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


  Future<void> share({
    required BuildContext context,
    required String text,
  }) async {
    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'Rafeeq • Ayah',
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}
