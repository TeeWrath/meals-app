import 'package:flutter/material.dart';
import 'package:annapurna/core/routes/app_route_const.dart';
import 'package:go_router/go_router.dart';
import 'package:annapurna/providers/meal_provider.dart';
import 'package:annapurna/view/dashboard/categories.dart';
import 'package:annapurna/view/meal/meals.dart';
import 'package:annapurna/core/widgets/drawers/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annapurna/providers/favorites_provider.dart';
import 'package:annapurna/view/meal/add_meal_screen.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key, required this.userName});

  final String userName;

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    // Use context.go or context.push instead of Navigator.pop/push
    if (identifier == 'filters') {
      context.push(RoutePath.filters);
    } else if (identifier == 'add_meal') {
      // For screens that need to return results, use push and handle the result
      final result = await context.push<bool?>(RoutePath.addMeal);
      if (result == true) {
        // Refresh meals if a new meal was added
        ref.read(mealProvider.notifier).getMeals();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();
    String activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          if (_selectedPageIndex == 0) // Only show on Categories tab
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _setScreen('add_meal'),
              tooltip: 'Add New Meal',
            ),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
        userName: widget.userName,
        profileImage: null,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
          ]),
    );
  }
}
