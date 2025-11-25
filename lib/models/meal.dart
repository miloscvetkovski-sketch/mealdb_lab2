class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String youtubeUrl;
  final List<MealIngredient> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
  });

  // За листа по категорија (filter.php)
  factory Meal.fromListJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      instructions: '',
      youtubeUrl: '',
      ingredients: const [],
    );
  }

  // За детален рецепт (lookup.php и random.php)
  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    final List<MealIngredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ing != null &&
          ing.toString().trim().isNotEmpty &&
          measure != null &&
          measure.toString().trim().isNotEmpty) {
        ingredients.add(
          MealIngredient(
            name: ing.toString().trim(),
            measure: measure.toString().trim(),
          ),
        );
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}

class MealIngredient {
  final String name;
  final String measure;

  MealIngredient({required this.name, required this.measure});
}
