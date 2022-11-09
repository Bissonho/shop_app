import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_list.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteSync(BuildContext context) async {
    _toggleFavorite();
    notifyListeners();
    final response = await Provider.of<ProductList>(context, listen: false)
        .updateFavorite(this);
    if (!response) {
      _toggleFavorite();
      notifyListeners();
    }
  }
}
