import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;

  const MealsScreen({super.key, required this.categoryName});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealApiService _api = MealApiService();
  List<Meal> _meals = [];
  List<Meal> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final data = await _api.fetchMealsByCategory(widget.categoryName);
    setState(() {
      _meals = data;
      _filtered = data;
      _loading = false;
    });
  }

  void searchLocal(String text) {
    setState(() {
      _filtered = _meals
          .where(
            (m) => m.name.toLowerCase().contains(text.toLowerCase()),
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search meals',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: searchLocal,
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final meal = _filtered[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MealDetailScreen(mealId: meal.id),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: Container(
                      padding: const EdgeInsets.all(6),
                      color: Colors.black54,
                      child: Text(
                        meal.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    child: Image.network(
                      meal.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
