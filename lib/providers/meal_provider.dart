import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:annapurna/models/meal.dart';

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super([]) {
    getMeals();
  }

  static const String baseUrl = 'https://annapurna-fpy6.onrender.com/api';

  // GET /api/meals: Retrieves a list of all meal blogs
  Future<List<Meal>> getMeals() async {
    final url = Uri.parse('$baseUrl/meals');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          state = [];
          return [];
        }

        // Decode the JSON response as a List
        final List<dynamic> mealsData = json.decode(response.body);
        print('Raw API response: ${response.body}');

        // Convert the List into a list of Meal objects
        final List<Meal> mealList = mealsData.map((mealData) {
          return Meal.fromJson(mealData as Map<String, dynamic>);
        }).toList();

        state = mealList;
        return mealList;
      } else {
        print(
            'Error fetching meals: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }

  // GET /api/meals/:id: Fetches a single meal blog by its unique ID
  Future<Meal?> getMealById(String id) async {
    final url = Uri.parse('$baseUrl/meals/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          return null;
        }
        final Map<String, dynamic> mealData = json.decode(response.body);
        return Meal.fromJson(mealData);
      } else {
        print(
            'Error fetching meal $id: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching meal $id: $e');
      return null;
    }
  }

  // POST /api/meals: Adds a new meal blog to the database
  Future<bool> addMeal(Meal meal) async {
    final url = Uri.parse('$baseUrl/meals');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(meal.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getMeals(); // Refresh the list
        return true;
      } else {
        print('Error adding meal: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding meal: $e');
      return false;
    }
  }

  // PUT /api/meals/:id: Updates an existing meal blog
  Future<bool> updateMeal(String id, Meal meal) async {
    final url = Uri.parse('$baseUrl/meals/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(meal.toJson()),
      );

      if (response.statusCode == 200) {
        await getMeals(); // Refresh the list
        return true;
      } else {
        print(
            'Error updating meal $id: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating meal $id: $e');
      return false;
    }
  }

  // DELETE /api/meals/:id: Deletes a meal blog
  Future<bool> deleteMeal(String id) async {
    final url = Uri.parse('$baseUrl/meals/$id');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        state = state.where((meal) => meal.id != id).toList();
        return true;
      } else {
        print(
            'Error deleting meal $id: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting meal $id: $e');
      return false;
    }
  }
}

final mealProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier();
});
