import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/api/client.dart';
import 'package:shopapp/providers/product_provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => List<Product>.of(_items);
  List<Product> get favoriteItem =>
      _items.where((el) => el.isFavorite).toList();

  Future<void> fetchProducts() async {
    const url = '/products.json';
    final response = await FirebaseClient.get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data != null) {
      _items = data.entries
          .map((e) => Product(
                id: e.key,
                title: e.value['title'],
                description: e.value['description'],
                price: e.value['price'],
                imageUrl: e.value['imageUrl'],
                isFavorite: e.value['isFavorite'],
              ))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    const url = '/products.json';
    final response = await FirebaseClient.post(
      url,
      body: {
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      },
    );
    final id = jsonDecode(response.body)['name'];
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: id,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    final url = '/products/$id.json';
    final response = await FirebaseClient.patch(
      url,
      body: {
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      },
    );
    final body = jsonDecode(response.body);
    if (body['error']) {
      throw body['error'];
    }
    _items[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = '/products/$id';
    final product = _items.firstWhere((element) => element.id == id);
    _items.remove(product);
    notifyListeners();
    final response = await FirebaseClient.delete(url);
    if (response.statusCode >= 400) {
      _items.add(product);
      notifyListeners();
      throw Exception('Can`t delete product');
    }
  }

  Product findById(String id) =>
      _items.firstWhere((element) => element.id == id);
}
