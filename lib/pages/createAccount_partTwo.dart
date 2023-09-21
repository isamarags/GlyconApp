import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class CreateAccountOne_Page extends StatefulWidget {
  const CreateAccountOne_Page({super.key});

  @override
  State<CreateAccountOne_Page> createState() => _CreateAccountOne_PageState();
}

class _CreateAccountOne_PageState extends State<CreateAccountOne_Page> {
  DateTime selectedDate = DateTime.now();

  List<String> gender = ["", "Masculino", "Feminino"];
  String selectedGender = ""; // Gênero padrão

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
                    SizedBox(width: 129),
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
                          Icon(Icons.calendar_today, color: Color(0xFF4B0D07)),
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
                SizedBox(height: 320),
                ElevatedButton(
                  onPressed: () => context.go('/createAccount_Two'),
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
