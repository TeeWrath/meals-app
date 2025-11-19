import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:annapurna/models/meal.dart';
import 'package:annapurna/providers/meal_provider.dart';
import 'package:annapurna/providers/categories_provider.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _durationController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _stepController = TextEditingController();

  final List<String> _selectedCategories = [];
  final List<String> _ingredients = [];
  final List<String> _steps = [];

  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _isVegetarian = false;
  bool _isVegan = false;
  bool _isLoading = false;

  // Complexity and Affordability defaults
  Complexity _complexity = Complexity.simple;
  Affordability _affordability = Affordability.affordable;

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addStep() {
    final step = _stepController.text.trim();
    if (step.isNotEmpty) {
      setState(() {
        _steps.add(step);
        _stepController.clear();
      });
    }
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (_selectedCategories.contains(categoryId)) {
        _selectedCategories.remove(categoryId);
      } else {
        _selectedCategories.add(categoryId);
      }
    });
  }

  Future<void> _submitMeal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one category')),
      );
      return;
    }
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }
    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newMeal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      imageUrl: _imageUrlController.text,
      categories: _selectedCategories,
      ingredients: _ingredients,
      steps: _steps,
      duration: int.tryParse(_durationController.text) ?? 0,
      isGlutenFree: _isGlutenFree,
      isLactoseFree: _isLactoseFree,
      isVegetarian: _isVegetarian,
      isVegan: _isVegan,
      complexity: _complexity,
      affordability: _affordability,
    );

    final success = await ref.read(mealProvider.notifier).addMeal(newMeal);

    setState(() {
      _isLoading = false;
    });

    // In your _submitMeal method, when success is true:
    if (success) {
      if (context.mounted) {
        context.pop(true); // Use context.pop instead of Navigator.pop
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add meal. Please try again.')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Meal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _submitMeal,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration:
                          const InputDecoration(labelText: 'Meal Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                          labelText: 'Duration (minutes)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    // Complexity Selection
                    const SizedBox(height: 16),
                    const Text('Complexity',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<Complexity>(
                      value: _complexity,
                      onChanged: (Complexity? newValue) {
                        setState(() {
                          _complexity = newValue!;
                        });
                      },
                      items: Complexity.values.map((Complexity complexity) {
                        return DropdownMenuItem<Complexity>(
                          value: complexity,
                          child: Text(
                            complexity.toString().split('.').last,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),

                    // Affordability Selection
                    const SizedBox(height: 16),
                    const Text('Affordability',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<Affordability>(
                      value: _affordability,
                      onChanged: (Affordability? newValue) {
                        setState(() {
                          _affordability = newValue!;
                        });
                      },
                      items: Affordability.values
                          .map((Affordability affordability) {
                        return DropdownMenuItem<Affordability>(
                          value: affordability,
                          child: Text(
                            affordability.toString().split('.').last,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),

                    // Categories Selection
                    const SizedBox(height: 16),
                    const Text('Categories',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allCategories.map((category) {
                        final isSelected =
                            _selectedCategories.contains(category.id);
                        return FilterChip(
                          label: Text(category.title),
                          selected: isSelected,
                          onSelected: (_) => _toggleCategory(category.id),
                          backgroundColor: category.color.withOpacity(0.1),
                          selectedColor: category.color.withOpacity(0.3),
                          checkmarkColor: category.color,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? category.color
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),

                    // Dietary Preferences
                    const SizedBox(height: 16),
                    const Text('Dietary Preferences',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Gluten Free'),
                          selected: _isGlutenFree,
                          onSelected: (value) =>
                              setState(() => _isGlutenFree = value),
                        ),
                        FilterChip(
                          label: const Text('Lactose Free'),
                          selected: _isLactoseFree,
                          onSelected: (value) =>
                              setState(() => _isLactoseFree = value),
                        ),
                        FilterChip(
                          label: const Text('Vegetarian'),
                          selected: _isVegetarian,
                          onSelected: (value) =>
                              setState(() => _isVegetarian = value),
                        ),
                        FilterChip(
                          label: const Text('Vegan'),
                          selected: _isVegan,
                          onSelected: (value) =>
                              setState(() => _isVegan = value),
                        ),
                      ],
                    ),

                    // Ingredients
                    const SizedBox(height: 16),
                    const Text('Ingredients',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ingredientController,
                            decoration: const InputDecoration(
                              labelText: 'Add Ingredient',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addIngredient,
                        ),
                      ],
                    ),
                    ..._ingredients.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ingredient = entry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(ingredient),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () => _removeIngredient(index),
                          ),
                        ),
                      );
                    }),

                    // Steps
                    const SizedBox(height: 16),
                    const Text('Steps',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stepController,
                            decoration: const InputDecoration(
                              labelText: 'Add Step',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addStep,
                        ),
                      ],
                    ),
                    ..._steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(step),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () => _removeStep(index),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitMeal,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Add Meal',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
