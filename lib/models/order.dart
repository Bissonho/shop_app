import 'cart_item.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime time;

  Order(this.id, this.total, this.products, this.time);
}
