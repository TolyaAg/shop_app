import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    final count = _items.entries.fold<int>(
        0, (previousValue, element) => previousValue += element.value.quantity);
    return count;
  }

  double get totalPrice {
    final totalPrice = _items.entries.fold<double>(
        0,
        (previousValue, element) =>
            previousValue += element.value.quantity * element.value.price);
    return totalPrice;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity + 1,
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    this.notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    this.notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity - 1,
          price: value.price,
        ),
      );
    } else {
      removeItem(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    this.notifyListeners();
  }
}
