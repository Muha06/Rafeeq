import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';

const List<DhikrCategory> adhkarCategories = [
  DhikrCategory(
    name: "Daily Routine",
    categoryIds: [1, 28], // waking + sleeping
  ),
  DhikrCategory(name: "Morning & Evening", categoryIds: [27]),
  DhikrCategory(
    name: "Home",
    categoryIds: [10, 11], // leaving + entering home
  ),
  DhikrCategory(name: "Mosque", categoryIds: [12, 13]),
  DhikrCategory(
    name: "Emotional States",
    categoryIds: [43, 82, 92], // difficulty, anger, shirk fear
  ),
  DhikrCategory(name: "Food & Fasting", categoryIds: [68, 69]),
  DhikrCategory(name: "Travel & Market", categoryIds: [96, 98]),
  DhikrCategory(name: "Salawat & Praise", categoryIds: [107, 108, 130]),
  DhikrCategory(name: "Repentance", categoryIds: [129]),
];
