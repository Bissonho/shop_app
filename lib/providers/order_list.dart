import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart_item.dart';
import '../utils/constante.dart';
import 'cart.dart';
import '../models/order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();
    final response = await http.get(Uri.parse('${constantes.ORDERS_URL}.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderid, orderdata) {
      _items.add(
        Order(
          orderid,
          orderdata['total'],
          (orderdata['products'] as List<dynamic>).map((item) {
            return CartItem(item['id'], item['productId'], item['name'],
                item['quantity'], item['price']);
          }).toList(),
          DateTime.parse(orderdata['date']),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final data = DateTime.now();

    final response = await http.post(
      Uri.parse('${constantes.ORDERS_URL}.json'),
      body: jsonEncode(
        {
          'total': cart.totalAmout,
          'date': data.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.producitIdId,
                    'name': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList()
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id,
        cart.totalAmout,
        cart.items.values.toList(),
        data,
      ),
    );

    notifyListeners();
  }
}
