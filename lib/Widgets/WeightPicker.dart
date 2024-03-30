import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class WeightPicker extends StatefulWidget {
  final TextEditingController? weightController;
  final String? selectedWeight;
  final Function(String) onWeightChanged;

  const WeightPicker(
      {Key? key,
      this.weightController,
      this.selectedWeight,
      required this.onWeightChanged})
      : super(key: key);

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  final double min = 0;
  final double max = 300;
  String selectedWeight = ''; // Defina o valor inicial aqui

  @override
  void initState() {
    selectedWeight = min.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        AlertDialog(
          title: Text(
            'Selecionar peso',
            style: GoogleFonts.montserrat(
              color: Color(0xFF4B0D07),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Escolha seu peso em quilogramas:',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF4B0D07),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              AnimatedWeightPicker(
                min: min,
                max: max,
                onChange: (newWeight) {
                  setState(() {
                    selectedWeight = newWeight.toString();
                    widget.onWeightChanged(newWeight.toString());
                  });
                },
                dialColor: Color(0xFF4B0D07),
                selectedValueColor: Color(0xFF4B0D07),
                suffixTextColor: Color(0xFF4B0D07),
                subIntervalColor: Color(0xFFD8A9A9),
                minorIntervalColor: Color(0xFFEFDED8),
                majorIntervalColor: Color(0xFFB98282),
              ),
              Text(
                'Peso selecionado: $selectedWeight kg',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF4B0D07),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.weightController?.text = selectedWeight;
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF4B0D07),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF4B0D07),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
