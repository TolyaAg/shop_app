import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/api/client.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String id) async {
    isFavorite = !isFavorite;
    this.notifyListeners();
    final url = '/products/$id.json';
    final response = await FirebaseClient.patch(
      url,
      body: {
        'isFavorite': isFavorite,
      },
    );
    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      this.notifyListeners();
      throw Exception('Can`t change favorite status!');
    }
  }
}
