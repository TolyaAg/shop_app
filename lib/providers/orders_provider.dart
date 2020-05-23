import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/api/client.dart';
import 'package:shopapp/providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => List.of(_orders);

  Future<String> fetchOrders() async {
    const url = '/orders.json';
    final response = await FirebaseClient.get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    List<OrderItem> loadedOrders = [];
    if (data != null) {
      loadedOrders = data.entries
          .map(
            (e) => OrderItem(
              id: e.key,
              amount: e.value['amount'],
              dateTime: DateTime.parse(e.value['dateTime']),
              products: (e.value['products'] as List<dynamic>)
                  .map(
                    (p) => CartItem(
                      id: p['id'],
                      title: p['title'],
                      quantity: p['quantity'],
                      price: p['price'],
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();
    }
    _orders = loadedOrders;
    notifyListeners();
    return 'done';
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    const url = '/orders.json';
    final dateTime = DateTime.now();
    final response = await FirebaseClient.post(url, body: {
      'amount': total,
      'products': products,
      'dateTime': dateTime.toIso8601String(),
    });
    final id = jsonDecode(response.body)['name'];
    _orders.add(
      OrderItem(
        id: id,
        amount: total,
        products: products,
        dateTime: dateTime,
      ),
    );
    this.notifyListeners();
  }
}
