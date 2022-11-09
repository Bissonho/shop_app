import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/utils/app_routes.dart';

import '../models/product.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.PRODUC_DETAIL, arguments: product);
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            leading: IconButton(
              onPressed: () {
                product.toggleFavoriteSync(context);
              },
              icon: product.isFavorite
                  ? Icon(Icons.favorite,
                      color: Theme.of(context).colorScheme.secondary)
                  : Icon(Icons.favorite_border,
                      color: Theme.of(context).colorScheme.secondary),
            ),
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("O Produto foi adicionado com sucesso"),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'DESFAZER',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                  cart.addItem(product);
                },
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
