import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:annapurna/core/routes/app_route_const.dart';
import 'package:annapurna/view/dashboard/categories.dart';
import 'package:annapurna/view/settings/filters.dart';
import 'package:annapurna/view/auth/login.dart';
import 'package:annapurna/view/auth/signup.dart';
import 'package:annapurna/view/auth/splash.dart';
import 'package:annapurna/view/dashboard/tabs.dart';
import 'package:annapurna/view/meal/add_meal_screen.dart';

class MyAppRoutes {
  static GoRouter returnRouter() {
    GoRouter routes = GoRouter(
      routes: [
        GoRoute(
          name: Routes.splash,
          path: RoutePath.splash,
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          },
        ),
        GoRoute(
          name: Routes.tabs,
          path: '${RoutePath.tabs}/:userName',
          pageBuilder: (context, state) {
            final userName = state.pathParameters['userName'] ?? '';
            return MaterialPage(child: TabsScreen(userName: userName));
          },
        ),
        GoRoute(
          name: Routes.login,
          path: RoutePath.login,
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          },
        ),
        GoRoute(
          name: Routes.signup,
          path: RoutePath.signup,
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignupScreen());
          },
        ),
        GoRoute(
          name: Routes.categories,
          path: RoutePath.categories,
          pageBuilder: (context, state) {
            return const MaterialPage(child: CategoriesScreen());
          },
        ),
        GoRoute(
          name: Routes.filters,
          path: RoutePath.filters,
          pageBuilder: (context, state) {
            return const MaterialPage(child: FiltersScreen());
          },
        ),
        GoRoute(
          name: Routes.addMeal,
          path: RoutePath.addMeal,
          pageBuilder: (context, state) {
            return const MaterialPage(child: AddMealScreen());
          },
        ),
        // GoRoute(
        //   name: Routes.meals,
        //   path: '/meals',
        //   pageBuilder: (context, state) {
        //     return MaterialPage(
        //         child: MealsScreen(
        //       meal: meal,
        //     ));
        //   },
        // ),
        // GoRoute(
        //   name: Routes.mealDetails,
        //   path: '/details/:meal',
        //   pageBuilder: (context, state) {
        //     return MaterialPage(
        //         child: MealDetailScreen(
        //       meal: state.pathParameters['meal']!,
        //     ));
        //   },
        // ),
      ],
    );
    return routes;
  }
}
