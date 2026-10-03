import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/features/whats_new/domain/entitites/whats_new_item.dart';

const currentWhatsNewVersion = '0.0.9'; // Version of this release

const whatsNewItems = [
  WhatsNewItem(
    icon: PhosphorIcons.compass,
    title: 'Qibla Compass',
    description: 'Find the Qibla direction with our new compass experience.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.bell,
    title: 'Better Salah reminders',
    description:
        'Improved notification handling and more reliable Salah times.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.calendarCheck,
    title: 'More reliable Salah times',
    description:
        'Extended Salah data storage so prayer times remain available more reliably.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.heart,
    title: 'Asmaul Husna',
    description:
        'Explore the beautiful 99 Names of Allah with their meanings and details.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.target,
    title: 'Improved Quran goals',
    description:
        'Fixed Quran goal progress tracking for a more accurate experience.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.mapPin,
    title: 'Better location handling',
    description:
        'Improved location detection and handling for a more reliable experience.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.textAa,
    title: 'Font improvements',
    description:
        'Fixed font issues and improved text consistency across the app.',
  ),
  WhatsNewItem(
    icon: PhosphorIcons.bug,
    title: 'Bug fixes & improvements',
    description:
        'We fixed a few issues and made Rafeeq smoother and more reliable.',
  ),
];
