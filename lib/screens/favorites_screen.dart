import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/meal_api_service.dart';
import '../models/meal.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final MealApiService _api = MealApiService();

  List<Meal> _favoriteMeals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final List<String> ids = await _favoritesService.getFavorites();
    List<Meal> meals = [];

    for (final id in ids) {
      final meal = await _api.fetchMealDetail(id);  // FIXED
      meals.add(meal);
    }

    setState(() {
      _favoriteMeals = meals;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteMeals.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
        itemCount: _favoriteMeals.length,
        itemBuilder: (_, i) {
          final meal = _favoriteMeals[i];

          return ListTile(
            leading: Image.network(meal.thumbnail, width: 60),
            title: Text(meal.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: meal.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
