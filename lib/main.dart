import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/pages/auth_or_home_page.dart';
import 'package:shop_app/pages/product_form_page.dart';
import 'package:shop_app/pages/products_page_edit.dart';
import 'package:shop_app/providers/order_list.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/ordes_page.dart';
import 'package:shop_app/pages/product_detail_page.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'providers/cart.dart';
import 'providers/product_list.dart';

void main(List<String> args) {
  runApp(const ShopApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: ((ctx, auth, previous) {
            return ProductList(
                auth.token ?? '', previous?.itens ?? [], auth.userId ?? '');
          }),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) {
            return OrderList(
                auth.token ?? '', previous?.items ?? [], auth.userId ?? '');
          },
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        routes: {
          AppRoutes.AUTH_OR_HOME: (context) => const AuthOrHomePage(),
          AppRoutes.HOME: (context) => const HomePage(),
          AppRoutes.PRODUC_DETAIL: ((context) => const ProductDetailPage()),
          AppRoutes.CART: ((context) => const CartPage()),
          AppRoutes.ORDERS: ((context) => const OrdersPage()),
          AppRoutes.PRODUCTS: ((context) => const ProductsPage()),
          AppRoutes.PRODUCTS_FORM: ((context) => const ProductForm()),
        },
        title: "Flutter Demo",
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.red)),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
