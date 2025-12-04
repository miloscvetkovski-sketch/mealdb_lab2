import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/category.dart';
import '../services/meal_api_service.dart';
import 'meals_screen.dart';
import 'favorites_screen.dart';
import 'meal_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final MealApiService _api = MealApiService();
  List<Category> _all = [];
  List<Category> _filtered = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();

    _initFirebaseMessaging();
    loadCategories();
  }

  // -----------------------------------------
  // FIREBASE MESSAGING SETUP
  // -----------------------------------------
  Future<void> _initFirebaseMessaging() async {
    // 1. Побарај дозвола
    await FirebaseMessaging.instance.requestPermission();

    // 2. Превземи device FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM TOKEN: $token");
    });

    // 3. Listener кога апликацијата е foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.notification?.title ?? "New Notification",
          ),
        ),
      );
    });

    // 4. Listener кога корисник клика на notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped the notification!");

      // Ако сакаш можеш да отвориш Random Meal:
      // openRandomMeal();
    });
  }

  // -----------------------------------------
  // LOAD CATEGORIES
  // -----------------------------------------
  Future<void> loadCategories() async {
    final data = await _api.fetchCategories();
    setState(() {
      _all = data;
      _filtered = data;
      _loading = false;
    });
  }

  // -----------------------------------------
  // SEARCH BAR
  // -----------------------------------------
  void filterCategories(String query) {
    setState(() {
      _search = query;
      _filtered = _all
          .where((cat) =>
          cat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // -----------------------------------------
  // OPEN RANDOM MEAL
  // -----------------------------------------
  Future<void> openRandomMeal() async {
    final meal = await _api.fetchRandomMeal();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id),
      ),
    );
  }

  // -----------------------------------------
  // UI
  // -----------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search categories',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, index) {
                final c = _filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      c.thumbnail,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(c.name),
                    subtitle: Text(
                      c.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MealsScreen(categoryName: c.name),
                        ),
                      );
                    },
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
