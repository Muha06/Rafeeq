import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/features/whats_new/domain/entitites/whats_new_item.dart';

const currentWhatsNewVersion = '0.1.3';

const whatsNewItems = [
  WhatsNewItem(
    icon: HugeIconsSolid.image01,
    title: 'Share as images',
    description: 'Share beautiful images of your favorite content.',
  ),
  WhatsNewItem(
    icon: HugeIconsSolid.heartAdd,
    title: 'Save favorite radio stations',
    description: 'Save your favorite Quran radio stations for quick access.',
  ),
  WhatsNewItem(
    icon: HugeIconsSolid.text,
    title: 'UI improvements',
    description: 'Refreshed colors for a cleaner, more consistent look.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.bug,
    title: 'Bug fixes & improvements',
    description: 'Fixed issues and made Rafeeq smoother and more reliable.',
  ),
];
