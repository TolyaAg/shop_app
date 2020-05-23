import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart' show CartProvider;
import 'package:shopapp/providers/orders_provider.dart';
import 'package:shopapp/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('Order Now'),
                    onPressed: () {
                      Provider.of<OrdersProvider>(
                        context,
                        listen: false,
                      ).addOrder(
                        cart.items.values.toList(),
                        cart.totalPrice,
                      );
                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final item = cart.items.values.toList()[index];
                return CartItem(
                  item.id,
                  item.price,
                  item.quantity,
                  item.title,
                );
              },
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
