import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';

class About extends StatefulWidget {
  final String? selectedWeight;

  const About({Key? key, this.selectedWeight}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  TextEditingController weightController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  List<String> gender = ["Selecione", "Masculino", "Feminino"];
  String selectedGender = "Selecione";

  double selectedHeight = 0.0;

  String selectedWeight = '';

  void openHeightSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HeightSelectionDialog();
      },
    );
  }

  void openWeightPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeightPicker(
          selectedWeight: selectedWeight,
          weightController: weightController,
          onWeightChanged: (newWeight) {
            setState(() {
              selectedWeight = newWeight;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.only(left: 35),
          onPressed: () => context.go('/'),
          color: Color(0xFF4B0D07),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 39),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nos conte mais sobre você',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFF4B0D07),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Seus parâmetros individuais são importantes para uma personalização detalhada',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFFB98282),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.person, color: Color(0xFF4B0D07)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Genero',
                        style: GoogleFonts.montserrat(
                            color: Color(0xFFB98282),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: 100),
                      DropdownButton<String>(
                        value: selectedGender,
                        onChanged: (String? newGender) {
                          setState(() {
                            selectedGender = newGender!;
                          });
                        },
                        items: gender.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(
                              gender,
                              style: GoogleFonts.montserrat(
                                color: Color(0xFF4B0D07),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.calendar_today,
                            color: Color(0xFF4B0D07)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Data de nascimento',
                        style: GoogleFonts.montserrat(
                          color: Color(0xFFB98282),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            if (date != null && date != selectedDate) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          });
                        },
                        child: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.fitness_center,
                            color: Color(0xFF4B0D07)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Peso (kg)',
                        style: GoogleFonts.montserrat(
                          color: Color(0xFFB98282),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => openWeightPicker(context),
                        child: Text(
                          'Selecionar',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.height, color: Color(0xFF4B0D07)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Altura (cm)',
                        style: GoogleFonts.montserrat(
                          color: Color(0xFFB98282),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                      GestureDetector(
                        onTap: () => openHeightSelectionDialog(context),
                        child: Text(
                          'Selecionar',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () => context.go('/health'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD8A9A9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(250, 54),
                    ),
                    child: Text(
                      'Continuar',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFF4B0D07),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
