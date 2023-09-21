import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class CreateAccountTwo_Page extends StatefulWidget {
  const CreateAccountTwo_Page({super.key});

  @override
  State<CreateAccountTwo_Page> createState() => _CreateAccountTwo_PageState();
}

class _CreateAccountTwo_PageState extends State<CreateAccountTwo_Page> {
  DateTime selectedDate = DateTime.now();

  List<String> typeDiabetes = ["","Tipo 1", "Tipo 2", "Gestacional"];
  String typeDiabetesSelected = "";
  
  List<String> optionsTreatment = ["", "Medicamento", "Insulina", "Dieta/Exercícios"];
  String selectedTreatment = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 39),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Informações de saúde',
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
                SizedBox(height: 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.bloodtype_rounded, color: Color(0xFF4B0D07), size: 28,),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Tipo de diabetes',
                      style: GoogleFonts.montserrat(
                          color: Color(0xFFB98282),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(width: 40),
                    DropdownButton<String>(
                      value: typeDiabetesSelected,
                      onChanged: (String? newTypeDiabetes) {
                        setState(() {
                          typeDiabetesSelected = newTypeDiabetes!;
                        });
                      },
                      items: typeDiabetes.map((String tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(
                            tipo,
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(Icons.medication, color: Color(0xFF4B0D07), size: 28),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Tratamento',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFB98282),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: selectedTreatment,
                      onChanged: (String? newTreatment) {
                        setState(() {
                          selectedTreatment = newTreatment!;
                        });
                      },
                      items: optionsTreatment.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: GoogleFonts.montserrat(
                              color: Color(0xFF4B0D07),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 320),
                ElevatedButton(
                  onPressed: () {},
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
    );
  }
}
