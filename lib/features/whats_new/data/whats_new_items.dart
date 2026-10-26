import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/features/whats_new/domain/entitites/whats_new_item.dart';

const currentWhatsNewVersion = '0.1.3'; // Version of this release

const whatsNewItems = [
  WhatsNewItem(
    icon: HugeIconsSolid.image01,
    title: 'Share ayah image',
    // fix description
    description: 'Watch Makkah and Madinah livestreams while browsing other parts of Rafeeq.',
  ),
  WhatsNewItem(
    icon: HugeIconsSolid.text,
    title: 'UI improvements',
    description: 'Improved typography, text consistency, and overall readability throughout the app.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.bug,
    title: 'Bug fixes & improvements',
    description:
        'We fixed a few issues and made Rafeeq smoother and more reliable.',
  ),
];
