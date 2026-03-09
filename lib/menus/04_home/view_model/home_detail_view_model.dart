import 'package:get/get.dart';

class HomeDetailViewModel extends GetxController {
  final Map<String, dynamic> recipeDetail = {
    'title': 'Spicy Avocado Toast',
    'time': '15 mins',
    'rating': 4.9,
    'reviews': '1.2k reviews',
    'calories': 385,
    'protein': '18g',
    'carbs': '24g',
    'fats': '22g',
    'match_percent': 98,
    'match_reason': 'This recipe is a 98% match for your goal of increasing lean muscle mass. The high healthy fat content from avocados paired with sourdough\'s low GI carbs provides sustained energy for your evening workout.',
    'image': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=800',
    'ingredients': [
      {
        'name': 'Avocado', 
        'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=200'
      },
      {
        'name': 'Sourdough', 
        'image': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=200'
      },
      {
        'name': 'Chili Flakes', 
        'image': 'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?q=80&w=200'
      },
      {
        'name': 'Radish', 
        'image': 'https://images.unsplash.com/photo-1594498653385-d5172c532c00?q=80&w=200'
      },
    ]
  };
}