import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class MealApiService {
  static const String _baseUrl = 'www.themealdb.com';

  // 1. Fetch all categories
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/categories.php');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final data = jsonDecode(response.body);
    final List list = data['categories'] ?? [];

    return list.map((e) => Category.fromJson(e)).toList();
  }

  // 2. Fetch meals by category
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/filter.php',
      {'c': category},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final data = jsonDecode(response.body);
    final List list = data['meals'] ?? [];

    return list.map((e) => Meal.fromListJson(e)).toList();
  }

  // 3. Search meals (search.php)
  Future<List<Meal>> searchMeals(String query) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/search.php',
      {'s': query},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Search failed');
    }

    final data = jsonDecode(response.body);
    final List? list = data['meals'];

    if (list == null) return [];

    return list.map((e) => Meal.fromDetailJson(e)).toList();
  }

  // 4. Fetch detailed recipe
  Future<Meal> fetchMealDetail(String id) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/lookup.php',
      {'i': id},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal detail');
    }

    final data = jsonDecode(response.body);
    final List list = data['meals'] ?? [];

    if (list.isEmpty) {
      throw Exception('Meal not found');
    }

    return Meal.fromDetailJson(list.first);
  }

  // 5. Random recipe
  Future<Meal> fetchRandomMeal() async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/random.php',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load random meal');
    }

    final data = jsonDecode(response.body);
    final List list = data['meals'] ?? [];

    return Meal.fromDetailJson(list.first);
  }
}
