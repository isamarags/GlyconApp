import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class HeightSelectionDialog extends StatefulWidget {
  final Function(double) onHeightChanged;
  final double initialHeight;

  const HeightSelectionDialog(
      {Key? key, required this.onHeightChanged, this.initialHeight = 1.60})
      : super(key: key);

  @override
  State<HeightSelectionDialog> createState() => _HeightSelectionDialogState();
}

class _HeightSelectionDialogState extends State<HeightSelectionDialog> {
  late double selectedHeight;

  @override
  void initState() {
    super.initState();
    selectedHeight = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecionar altura'),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Escolha sua altura em centímetros:'),
          SizedBox(height: 20),
          DropdownButton<double>(
            value: selectedHeight,
            dropdownColor: Color.fromARGB(255, 255, 255, 255),
            onChanged: (value) {
              setState(() {
                selectedHeight = value!;
              });
            },
            items: List.generate(200, (index) => (index + 100) / 100.0)
                .map((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text(value.toStringAsFixed(2)),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar', 
            style: TextStyle(color: Color(0xFF4B0D07))),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(selectedHeight);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4B0D07),
          ),
          child: Text(
            'OK', 
            style: TextStyle(color: Color(0xFFFFFFFF))),
        ),
      ],
    );
  }
}
