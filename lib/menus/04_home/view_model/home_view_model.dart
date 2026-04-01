import 'package:get/get.dart';

import '../../../utils/data_session_util_controller.dart';

class HomeViewModel extends GetxController {
  final DataSessionUtilController session;
  final RxString userName = 'Axel Darmawan'.obs;

  HomeViewModel({
    required this.session
  });

  final List<Map<String, dynamic>> recommendedRecipes = [
    {
      'title': 'Spicy Avocado Toast',
      'subtitle': 'High Protein • Under 400 kcal',
      'match': 98,
      'time': '15 min',
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=500',
    },
    {
      'title': 'Quinoa Power Bowl',
      'subtitle': 'Nutrient Dense • Vegan',
      'match': 92,
      'time': '25 min',
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500',
    },
    {
      'title': 'Mediterranean Salmon',
      'subtitle': 'Healthy Fats • Omega 3',
      'match': 95,
      'time': '30 min',
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=500',
    },
    {
      'title': 'Berry Oat Parfait',
      'subtitle': 'Energy Booster • Fiber Rich',
      'match': 89,
      'time': '10 min',
      'rating': 4.6,
      'image': 'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=500',
    }
  ];

  final List<Map<String, dynamic>> topSearching = [
    {'name': 'Salad', 'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=100'},
    {'name': 'Pasta', 'image': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=100'},
    {'name': 'Steak', 'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=100'},
    {'name': 'Tacos', 'image': 'https://images.unsplash.com/photo-1512838243191-e81e8f66f1fd?q=80&w=100'},
    {'name': 'Pizza', 'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=100'},
    {'name': 'Burger', 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=100'},
  ];
}