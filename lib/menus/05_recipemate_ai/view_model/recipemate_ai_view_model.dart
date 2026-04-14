import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipemateAiViewModel extends GetxController {
  final RxList<String> selectedIngredients = <String>['Tomato'].obs;
  final RxString searchText = 'Ba'.obs;

  // PAKAI DUMMY DULU
  final List<Map<String, dynamic>> suggestions = [
    {'name': 'Basil', 'image': 'assets/images/basil.png', 'icon': Icons.eco},
    {'name': 'Banana', 'image': 'assets/images/banana.png', 'icon': Icons.restaurant},
    {'name': 'Barley', 'image': 'assets/images/barley.png', 'icon': Icons.grain},
  ];

  final List<Map<String, dynamic>> bestMatches = [
    {
      'title': 'Classic Tomato Basil Caprese',
      'match': 98,
      'kcal': '320 kcal',
      'protein': '12g Protein',
      'time': '15 min',
      'status': 'All ingredients found in your list',
      'image': 'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14a5?q=80&w=500',
    },
    {
      'title': 'Tuscan Sun-Dried Tomato Penne',
      'match': 85,
      'kcal': '450 kcal',
      'protein': '14g Protein',
      'time': '25 min',
      'status': 'Missing: Heavy Cream',
      'image': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=500',
    },
    {
      'title': 'Herbed Roasted Tomato Soup',
      'match': 72,
      'kcal': '180 kcal',
      'protein': '4g Protein',
      'time': '40 min',
      'status': 'Missing: Fresh Thyme, Garlic',
      'image': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=500',
    }
  ];

  void removeIngredient(String name) {
    selectedIngredients.remove(name);
  }
}