import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/getUserData.dart';
import 'package:glycon_app/Services/FirebaseFunctions.dart';

class Health extends StatefulWidget {
  const Health({Key? key}) : super(key: key);

  @override
  State<Health> createState() => _HealthState();
}

class _HealthState extends State<Health> {
  DateTime selectedFundoscopiaDate = DateTime.now();
  DateTime selectedRACDate = DateTime.now(); 

  List<String> typeDiabetes = ["Selecionar", "Tipo 1", "Tipo 2", "Gestacional"];
  String typeDiabetesSelected = "Selecionar";

  List<String> optionsTreatment = [
    "Medicamento",
    "Insulina",
    "Dieta",
    "Exercício físico"
  ];
  List<String> selectedTreatments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.only(left: 35),
          onPressed: () => context.go('/about'),
          color: Color(0xFF4B0D07),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 39),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
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
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bloodtype_rounded,
                    color: Color(0xFF4B0D07),
                    size: 28,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Tipo de diabetes',
                  style: GoogleFonts.montserrat(
                    color: Color(0xFFB98282),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: typeDiabetesSelected,
                    onChanged: (String? newTypeDiabetes) async {
                      String userId =
                          await FirebaseFunctions.getUserIdFromFirestore();
                      setState(() {
                        typeDiabetesSelected = newTypeDiabetes!;
                        GetUserData.saveUserDiabetesTypeToFirestore(
                            userId, newTypeDiabetes);
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Último exame Fundoscopia',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFFB98282),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '(Exame fundo de olho)',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFFB98282),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: selectedFundoscopiaDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((date) {
                      if (date != null && date != selectedFundoscopiaDate) {
                        setState(() {
                          selectedFundoscopiaDate = date;
                        });
                      }
                    });
                  },
                  child: Text(
                    '${selectedFundoscopiaDate.day}/${selectedFundoscopiaDate.month}/${selectedFundoscopiaDate.year}',
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
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Último exame RAC',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFFB98282),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '(Relação Albumina/Creatinina)',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFFB98282),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: selectedRACDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((date) {
                      if (date != null && date != selectedRACDate) {
                        setState(() {
                          selectedRACDate = date;
                        });
                      }
                    });
                  },
                  child: Text(
                    '${selectedRACDate.day}/${selectedRACDate.month}/${selectedRACDate.year}',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF4B0D07),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 90),
            ElevatedButton(
              onPressed: () async {
                String userId =
                    await FirebaseFunctions.getUserIdFromFirestore();

                GetUserData.saveUserFundoscopiaDateToFirestore(
                    userId, selectedFundoscopiaDate);
                GetUserData.saveUserRACDateToFirestore(userId, selectedRACDate);

                context.go('/homePage');
              },
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
    );
  }
}
