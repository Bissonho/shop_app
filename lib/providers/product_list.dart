import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/product.dart';
import 'package:shop_app/utils/constante.dart';
import '../exceptions/http_exception.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Product> _itens = [];

  ProductList([this._token = '', this._itens = const [], this._userId = '']);

  List<Product> get itens {
    return [..._itens];
  }

  int get itemsCount {
    return _itens.length;
  }

  List<Product> get favoriteItens {
    return _itens.where((prod) => prod.isFavorite).toList();
  }

  Future<void> addProdcut(Product product) async {
    final response = await http.post(
      Uri.parse('${constantes.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _itens.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        isFavorite: product.isFavorite,
        imageUrl: product.imageUrl));
    notifyListeners();
  }

  Future<void> removeProduct(Product product) async {
    int index = _itens.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      final product = _itens[index];
      _itens.remove(product);
      notifyListeners();
      final response = await http.delete(Uri.parse(
          '${constantes.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'));

      if (response.statusCode >= 400) {
        _itens.insert(index, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possível excluir o produto',
            statusCode: response.statusCode);
      }
    }
  }

  Future<void> loadProducts() async {
    _itens.clear();
    final response = await http
        .get(Uri.parse('${constantes.PRODUCT_BASE_URL}.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${constantes.USER_FAVORITE_URL}/$_userId/.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productid, productdata) {
      final isFavorite = favData[productid] ?? false;
      _itens.add(
        Product(
            id: productid,
            name: productdata['name'],
            description: productdata['description'],
            price: productdata['price'],
            isFavorite: isFavorite,
            imageUrl: productdata['imageUrl']),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['descripition'] as String,
        price: data['price'] as double,
        imageUrl: data['imageUrl'] as String);

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProdcut(newProduct);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _itens.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      final response = await http.patch(
        Uri.parse(
            '${constantes.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      if (response.statusCode >= 400) {
        throw response.statusCode;
      }
      _itens[index] = product;
      notifyListeners();
    }
  }

  Future<bool> updateFavorite(Product product) async {
    int index = _itens.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _itens[index] = product;

      try {
        final response = await http.put(
          Uri.parse(
              '${constantes.USER_FAVORITE_URL}/$_userId/${product.id}.json?auth=$_token'),
          body: jsonEncode(product.isFavorite),
        );
        if (response.statusCode >= 400) {
          return Future.value(false);
        }
        notifyListeners();
        return Future.value(true);
      } catch (error) {
        return Future.value(false);
      }
    }
    return Future.value(false);
  }
}
