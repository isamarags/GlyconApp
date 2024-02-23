import 'package:flutter/material.dart';

class CustomCounter extends StatelessWidget {
  final Function() onIncrement;
  final Function() onDecrement;
  final int quantity;

  CustomCounter({
    required this.onIncrement,
    required this.onDecrement,
    required this.quantity, // Adicionado
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onDecrement,
        ),
        Text(
          '$quantity', // Modificado para exibir a quantidade atual
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
