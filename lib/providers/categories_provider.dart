// providers/category_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:annapurna/models/category.dart';
import 'package:annapurna/providers/meal_provider.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super([]) {
    getCategories();
  }

  static const String baseUrl = 'https://annapurna-fpy6.onrender.com/api';

  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          state = [];
          return [];
        }

        final List<dynamic> categoriesData = json.decode(response.body);
        final List<Category> categoryList = categoriesData.map((categoryData) {
          return Category.fromJson(categoryData as Map<String, dynamic>);
        }).toList();

        state = categoryList;
        return categoryList;
      } else {
        print(
            'Error fetching categories: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<Category?> getCategoryById(String id) async {
    final categories = state;
    return categories.firstWhere((category) => category.id == id,
        orElse: () => throw Exception('Category not found'));
  }
}

final categoryProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier();
});

// Provider that provides available categories based on meals data
final availableCategoriesProvider = Provider<List<Category>>((ref) {
  final meals = ref.watch(mealProvider);
  final allCategories = ref.watch(categoryProvider);

  if (meals.isEmpty || allCategories.isEmpty) {
    return allCategories;
  }

  // Get all unique category IDs from meals
  final Set<String> usedCategoryIds = {};
  for (final meal in meals) {
    usedCategoryIds.addAll(meal.categories);
  }

  // Return only categories that are actually used in meals
  return allCategories
      .where((category) => usedCategoryIds.contains(category.id))
      .toList();
});

// Provider for all possible categories (for AddMealScreen)
final allCategoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(categoryProvider);
});
