import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String key = 'favorite_meals';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> toggleFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(key) ?? [];

    if (favorites.contains(mealId)) {
      favorites.remove(mealId);
    } else {
      favorites.add(mealId);
    }

    await prefs.setStringList(key, favorites);
  }

  Future<bool> isFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(key) ?? [];
    return favorites.contains(mealId);
  }
}
