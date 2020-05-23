import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders_provider.dart' show OrdersProvider;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: OrdersList(),
    );
  }
}

class OrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
      builder: (ctx, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Consumer<OrdersProvider>(
          builder: (ctx, orderData, _) {
            return ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, index) {
                final order = orderData.orders[index];
                return OrderItem(order);
              },
            );
          },
        );
      },
    );
  }
}
