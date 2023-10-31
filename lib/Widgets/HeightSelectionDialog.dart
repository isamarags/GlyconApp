import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class HeightSelectionDialog extends StatefulWidget {
const HeightSelectionDialog({Key? key}) : super(key: key);

  @override
  State<HeightSelectionDialog> createState() => _HeightSelectionDialogState();
}

class _HeightSelectionDialogState extends State<HeightSelectionDialog> {
  double selectedHeight = 160.0;

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
            'Selecionar altura', 
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
                'Escolha sua altura em centímetros:',            
                style: GoogleFonts.montserrat(
                  color: Color(0xFF4B0D07),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Slider(
                thumbColor: Color(0xFF4B0D07),
                activeColor: Color(0xFFD8A9A9),
                inactiveColor: Color.fromARGB(144, 216, 169, 169),
                value: selectedHeight,
                min: 100,
                max: 220,
                onChanged: (newHeight) {
                  setState(() {
                    selectedHeight = newHeight;
                  });
                },
              ),
              Text(
                'Altura selecionada: ${selectedHeight.toStringAsFixed(1)} cm',
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