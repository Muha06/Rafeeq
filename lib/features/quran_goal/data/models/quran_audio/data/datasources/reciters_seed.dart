import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/reciter_entity.dart';

/// Hardcoded reciters (from /resources/chapter_reciters).
/// Keep duplicates if IDs differ (they can map to different audio sets/variants).
const kQuranRecitersSeed = <ReciterEntity>[
  ReciterEntity(id: 19, name: 'Ahmed ibn Ali al-Ajmy'),
  ReciterEntity(id: 158, name: 'Abdullah Ali Jabir'),
  ReciterEntity(id: 160, name: 'Bandar Baleela'),
  ReciterEntity(id: 159, name: 'Maher al-Muaiqly'),

  // Same name, different IDs (different variants on the API)
  ReciterEntity(id: 2, name: 'Abdul Basit Abdul Samad'),
  ReciterEntity(id: 1, name: 'Abdul Basit Abdul Samad'),

  ReciterEntity(id: 6, name: 'Mahmoud Khalil Al-Husary'),
  ReciterEntity(id: 7, name: 'Mishari Rashid al-`Afasy'),
  ReciterEntity(id: 3, name: 'Abdur-Rahman as-Sudais'),
  ReciterEntity(id: 9, name: 'Muhammad Siddiq al-Minshawi'),
  ReciterEntity(id: 4, name: 'Abu Bakr al-Shatri'),
  ReciterEntity(id: 10, name: 'Sa`ud ash-Shuraym'),
  ReciterEntity(id: 161, name: 'Khalifah Al Tunaiji'),
  ReciterEntity(id: 13, name: 'Saad al-Ghamdi'),
  ReciterEntity(id: 5, name: 'Hani ar-Rifai'),
  ReciterEntity(id: 175, name: 'Abdullah Hamad Abu Sharida'),
  ReciterEntity(id: 12, name: 'Mahmoud Khalil Al-Husary'),

  // Variants
  ReciterEntity(id: 173, name: 'Mishari Rashid al-`Afasy (Streaming)'),
  ReciterEntity(id: 168, name: 'Muhammad Siddiq al-Minshawi (with kids)'),
  ReciterEntity(id: 174, name: 'Yasser ad-Dussary'),
];
