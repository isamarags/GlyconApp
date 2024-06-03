import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class WeightPicker extends StatefulWidget {
  final TextEditingController? weightController;
  final double? selectedWeight;
  final Function(double) onWeightChanged;

  const WeightPicker({
    Key? key,
    this.weightController,
    this.selectedWeight,
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    weightController =
        TextEditingController(text: widget.selectedWeight?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Valor corporal'),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: 'Insira seu peso aqui',
              hintStyle: TextStyle(fontSize: 14),
            ),
            onChanged: (value) {
              setState(() {
                widget.onWeightChanged(double.tryParse(value) ?? 0);
              });
            },
          ),
          SizedBox(height: 20),
          Text('Peso inserido: ${weightController.text} kg'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.weightController?.text = weightController.text;
            Navigator.of(context).pop();
          },
          child: Text('Cancelar', style: TextStyle(color: Color(0xFF4B0D07))),
        ),
        TextButton(
          onPressed: () {
            double weight = double.tryParse(weightController.text) ?? 0;
            Navigator.of(context).pop(weight);
          },
          child: Text('OK', style: TextStyle(color: Color(0xFF4B0D07))),
        ),
      ],
    );
  }
}
