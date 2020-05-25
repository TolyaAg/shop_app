import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/helpers/custom_route.dart';
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
import 'package:shopapp/api/client.dart';

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
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        home: HomePage(),
        routes: {
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.isAuth) {
      FirebaseClient.token = auth.token;
    }
    return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
  }
}
