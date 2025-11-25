import 'package:flutter/material.dart';
import '../services/meal_api_service.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _api = MealApiService();
  Meal? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  Future<void> loadMeal() async {
    final data = await _api.fetchMealDetail(widget.mealId);
    setState(() {
      _meal = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final meal = _meal;

    if (meal == null) {
      return const Scaffold(
        body: Center(child: Text('Meal not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(meal.thumbnail),
            ),

            const SizedBox(height: 20),

            // TITLE
            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // INGREDIENTS
            const Text(
              "Ingredients",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            ...meal.ingredients.map((ing) {
              return Text("${ing.measure} - ${ing.name}");
            }),

            const SizedBox(height: 20),

            // INSTRUCTIONS
            const Text(
              "Instructions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            Text(meal.instructions),

            const SizedBox(height: 20),

            // YOUTUBE
            if (meal.youtubeUrl.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "YouTube",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    meal.youtubeUrl,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
