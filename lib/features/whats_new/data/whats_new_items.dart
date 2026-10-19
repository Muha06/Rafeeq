import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/features/whats_new/domain/entitites/whats_new_item.dart';

const currentWhatsNewVersion = '0.1.0'; // Version of this release

const whatsNewItems = [
  WhatsNewItem(
    icon: HugeIconsSolid.kaaba01,
    title: 'Haramain mini player',
    description: 'Watch Makkah and Madinah livestreams while browsing other parts of Rafeeq.',
  ),
  WhatsNewItem(
    icon: HugeIconsSolid.quran01,
    title: 'Quran Word by Word',
    description: 'Explore the Quran with our new Word by Word feature, providing detailed insights and translations for each word.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.textAa,
    title: 'Prayer times calculation methods',
    description: 'Refresh your current location to update the city used for prayer times.',
  ),
    WhatsNewItem(
    icon: PhosphorIcons.mapPin,
    title: 'Refresh current location',
    description: 'Added multiple calculation methods for prayer times, allowing you to choose the one that best suits your location and preferences.',
  ),
  WhatsNewItem(
    icon: HugeIconsSolid.tasbih,
    title: 'Adhkar Category images',
    description: 'Added images to Adhkar categories for a more visually appealing experience.',
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
