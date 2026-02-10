// dto_mappers.dart (or wherever you keep mappers)

import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/name_model.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';

//DTO ->  HIVE
extension AllahNameDtoX on AllahNameDto {
  AllahNameHive toHive() => AllahNameHive(
    number: number,
    nameAr: arabic,
    transliteration: transliteration,
    meaningEn: meaningEn,
  );
}

//TO ENTITY
extension AllahNameHiveX on AllahNameHive {
  AllahName toEntity() => AllahName(
    number: number,
    arabic: nameAr,
    transliteration: transliteration,
    meaningEn: meaningEn,
  );
}
