import 'package:firebase_database/firebase_database.dart';
import 'package:recipemate/models/favorite_recipe.dart';
import 'package:recipemate/repository/realtime_paths.dart';

class FavoritesRealtimeRepository {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<List<FavoriteRecipe>> watchFavorites() {
    try {
      final ref = _db.ref(RealtimePaths.favorites()).orderByChild('savedAt');
      ref.keepSynced(true);
      return ref.onValue.map((event) {
        final data = event.snapshot.value;
        if (data == null || data is! Map) return [];

        final list = <FavoriteRecipe>[];
        for (var child in event.snapshot.children) {
          try {
            list.add(FavoriteRecipe.fromSnapshot(child));
          } catch (_) {}
        }
        list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
        return list;
      });
    } catch (_) {
      return Stream.value([]);
    }
  }

  Future<void> add(FavoriteRecipe recipe) async {
    final ref = _db.ref(RealtimePaths.favorite(recipe.id));
    await ref.set(recipe.toMap());
  }

  Future<void> remove(int recipeId) async {
    final ref = _db.ref(RealtimePaths.favorite(recipeId));
    await ref.remove();
  }
}
