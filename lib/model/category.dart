import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final int categoryId;
  final String name;
  final IconData icon;

  Category({required this.categoryId, required this.name, required this.icon});
}

final allCategory = Category(
  categoryId: 0,
  name: "All",
  icon: Icons.list_rounded,
);

final musicCategory = Category(
  categoryId: 1,
  name: "Music",
  icon: Icons.music_note,
);

final foodCategory = Category(
  categoryId: 2,
  name: "Food",
  icon: Icons.food_bank_rounded,
);

final sportCategory = Category(
  categoryId: 3,
  name: "Sports",
  icon: Icons.sports_football,
);

final healthCategory = Category(
  categoryId: 4,
  name: "Health",
  icon: Icons.masks,
);
final politicsCategory = Category(
  categoryId: 5,
  name: "Politics",
  icon: Icons.flag,
);

final cultureCategory = Category(
  categoryId: 6,
  name: "Culture",
  icon: Icons.castle,
);

final categories = [
  allCategory,
  musicCategory,
  foodCategory,
  sportCategory,
  healthCategory,
  politicsCategory,
  cultureCategory
];
