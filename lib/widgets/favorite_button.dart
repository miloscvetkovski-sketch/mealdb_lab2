import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

class FavoriteButton extends StatefulWidget {
  final String mealId;

  const FavoriteButton({super.key, required this.mealId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoritesService _service = FavoritesService();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final fav = await _service.isFavorite(widget.mealId);
    setState(() => isFav = fav);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () async {
        await _service.toggleFavorite(widget.mealId);
        load();
      },
    );
  }
}
