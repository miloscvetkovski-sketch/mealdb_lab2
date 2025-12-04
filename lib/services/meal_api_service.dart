import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class MealApiService {
  static const String _baseUrl = 'www.themealdb.com';

  // Fetch all categories
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/categories.php');
    final res = await http.get(uri);
    final data = jsonDecode(res.body);

    return (data['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  // Fetch meals by category
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/filter.php',
      {'c': category},
    );
    final res = await http.get(uri);
    final data = jsonDecode(res.body);

    return (data['meals'] as List)
        .map((e) => Meal.fromListJson(e))
        .toList();
  }

  // Fetch detailed meal info (used in detail screen)
  Future<Meal> fetchMealDetail(String id) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/lookup.php',
      {'i': id},
    );
    final res = await http.get(uri);
    final data = jsonDecode(res.body);

    return Meal.fromDetailJson(data['meals'][0]);
  }

  // REQUIRED: Fetch meal by ID (used in FavoritesScreen)
  Future<Meal?> fetchMealById(String id) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/lookup.php',
      {'i': id},
    );
    final res = await http.get(uri);

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);

    if (data['meals'] == null) return null;

    return Meal.fromDetailJson(data['meals'][0]);
  }

  // Fetch random meal (for random button)
  Future<Meal> fetchRandomMeal() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/random.php');
    final res = await http.get(uri);
    final data = jsonDecode(res.body);

    return Meal.fromDetailJson(data['meals'][0]);
  }
}
