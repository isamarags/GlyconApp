import 'package:flutter/material.dart';

class CustomCounter extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CustomCounter({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onDecrement,
        ),
        Text(
          '$quantity',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF4B0D07),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
