import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const MealDBApp());
}

class MealDBApp extends StatelessWidget {
  const MealDBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const CategoriesScreen(),
    );
  }
}
