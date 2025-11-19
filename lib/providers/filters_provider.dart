// providers/filters_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:annapurna/models/meal.dart';
import 'package:annapurna/providers/meal_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void resetFilters() {
    state = {
      Filter.glutenFree: false,
      Filter.lactoseFree: false,
      Filter.vegetarian: false,
      Filter.vegan: false
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filtersProvider);

  print("Total meals fetched: ${meals.length}");
  print("Active filters: $activeFilters");

  if (meals.isEmpty) {
    print("No meals available for filtering");
    return [];
  }

  final filteredMeals = meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();

  print("Filtered meals count: ${filteredMeals.length}");
  return filteredMeals;
});

// Provider to check if any filters are active
final hasActiveFiltersProvider = Provider<bool>((ref) {
  final activeFilters = ref.watch(filtersProvider);
  return activeFilters.values.any((isActive) => isActive);
});

// Provider to get active filters count
final activeFiltersCountProvider = Provider<int>((ref) {
  final activeFilters = ref.watch(filtersProvider);
  return activeFilters.values.where((isActive) => isActive).length;
});
