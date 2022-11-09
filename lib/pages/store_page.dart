import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/badge.dart';
import 'package:shop_app/providers/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';
import '../components/app_drawer.dart';
import '../components/product_grid.dart';
import '../providers/cart.dart';

enum FilterOptions { Favorite, All }

enum TabItem { red, green, blue }

class StorePage extends StatelessWidget {
  const StorePage({super.key, required this.onlyFavorite});

  final bool onlyFavorite;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: onlyFavorite ? const Text("Favoritos") : const Text("Home"),
        actions: [
          Consumer<Cart>(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART);
                },
                icon: const Icon(Icons.shopping_cart)),
            builder: (context, cart, child) =>
                Badge(value: cart.itemsCount.toString(), child: child!),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ProductList>(context, listen: false).loadProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ProductGrid(showFavoriteOnly: onlyFavorite);
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
