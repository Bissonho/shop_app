import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      subtitle: Text('Valor R\$${widget.order.total}'),
      title: Text('Pedido código ${widget.order.id}'),
      leading: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text(
          DateFormat('dd/MM/yyyy').format(widget.order.time),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      children: <Widget>[
        ...widget.order.products.map((product) {
          return ListTile(
            title: Text(product.name),
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  '${product.quantity.toString()}x',
                  style: const TextStyle(color: Colors.white),
                )),
            trailing: Text('R\$${product.quantity * product.price}'),
          );
        })
      ],
    );
  }
}
