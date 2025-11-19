import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annapurna/models/meal.dart';
import 'package:annapurna/providers/meal_provider.dart';

final mealByIdProvider = FutureProvider.family<Meal?, String>((ref, id) async {
  final mealsNotifier = ref.read(mealProvider.notifier);
  return await mealsNotifier.getMealById(id);
});
