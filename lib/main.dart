import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth_provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/providers/orders_provider.dart';
import 'package:shopapp/providers/products_providers.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          primaryTextTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: AuthScreen.routeName,
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          UserProductsScreen.routeName: (_) => UserProductsScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen(),
        },
      ),
    );
  }
}
