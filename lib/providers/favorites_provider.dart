import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:annapurna/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.any((m) => m.id == meal.id);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }

  bool isMealFavorite(String mealId) {
    return state.any((meal) => meal.id == mealId);
  }

  void clearFavorites() {
    state = [];
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});

// Helper provider to check if a specific meal is favorite
final isMealFavoriteProvider = Provider.family<bool, String>((ref, mealId) {
  final favorites = ref.watch(favoriteMealsProvider);
  return favorites.any((meal) => meal.id == mealId);
});
