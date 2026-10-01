import 'package:firebase_database/firebase_database.dart';
import 'package:recipemate/models/model_response/detail_recipe_response.dart';
import 'package:recipemate/models/model_response/search_recipes_response.dart';

class FavoriteRecipe {
  final int id;
  final String title;
  final String? image;
  final int? readyInMinutes;
  final int? aggregateLikes;
  final int savedAt;

  FavoriteRecipe({
    required this.id,
    required this.title,
    this.image,
    this.readyInMinutes,
    this.aggregateLikes,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'readyInMinutes': readyInMinutes,
      'aggregateLikes': aggregateLikes,
      'savedAt': savedAt,
    };
  }

  factory FavoriteRecipe.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value;
    if (data == null || data is! Map) {
      throw Exception('Invalid favorite data snapshot');
    }
    final map = Map<String, dynamic>.from(data);
    return FavoriteRecipe(
      id: (map['id'] as num?)?.toInt() ?? int.tryParse(snapshot.key ?? '0') ?? 0,
      title: (map['title'] ?? '') as String,
      image: map['image'] as String?,
      readyInMinutes: (map['readyInMinutes'] as num?)?.toInt(),
      aggregateLikes: (map['aggregateLikes'] as num?)?.toInt(),
      savedAt: (map['savedAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory FavoriteRecipe.fromSearch(Results result) {
    return FavoriteRecipe(
      id: result.id ?? 0,
      title: result.title ?? '',
      image: result.image,
      readyInMinutes: result.readyInMinutes,
      aggregateLikes: result.aggregateLikes,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory FavoriteRecipe.fromDetail(DetailRecipeResponse detail) {
    return FavoriteRecipe(
      id: detail.id ?? 0,
      title: detail.title ?? '',
      image: detail.image,
      readyInMinutes: detail.readyInMinutes,
      aggregateLikes: detail.aggregateLikes,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
