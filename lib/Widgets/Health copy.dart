import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/getUserData.dart';
import 'package:glycon_app/Services/FirebaseFunctions.dart';

class ChangeHealth extends StatefulWidget {
  const ChangeHealth({Key? key}) : super(key: key);

  @override
  State<ChangeHealth> createState() => _ChangeHealthState();
}

class _ChangeHealthState extends State<ChangeHealth> {
  DateTime selectedFundoscopiaDate = DateTime.now();
  DateTime currentFundoscopiaDate = DateTime.now();
  DateTime selectedRACDate = DateTime.now();
  DateTime currentRACDate = DateTime.now();
  List<String> typeDiabetes = ["Editar", "Tipo 1", "Tipo 2", "Gestacional"];
  late String loadSelectedDiabetesType = "Editar";
  String selectedDiabetesType = '';
  String currentDiabetesType = '';

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  void loadUserData() async {
    try {
      String userId = await FirebaseFunctions.getUserIdFromFirestore();

      String currentDiabetesType =
          await GetUserData.getUserDiabetesTypeFromFirestore(userId);
      DateTime fundoscopiaDate =
          await GetUserData.getUserFundoscopiaDateFromFirestore(userId);
      DateTime RACDate = await GetUserData.getUserRACDateFromFirestore(userId);

      setState(() {
        loadSelectedDiabetesType = currentDiabetesType;
        selectedDiabetesType = currentDiabetesType;
        selectedFundoscopiaDate = fundoscopiaDate;
        selectedRACDate = RACDate;
      });
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.only(left: 35),
          onPressed: () => context.go('/profilePage'),
          color: Color(0xFF4B0D07),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 39),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Editar informações de saúde',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bloodtype_rounded,
                            color: Color(0xFF4B0D07),
                            size: 28,
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
                        ],
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: loadSelectedDiabetesType,
                        onChanged: (String? newTypeDiabetes) {
                          if (newTypeDiabetes != null) {
                            setState(() {
                              loadSelectedDiabetesType = newTypeDiabetes;
                            });
                          }
                        },
                        items: typeDiabetes.map((String tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(
                              tipo,
                              style: GoogleFonts.montserrat(
                                color: Color(0xFF4B0D07),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1,
                  ),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xFF4B0D07)),
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
                            if (date != null &&
                                date != selectedFundoscopiaDate) {
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
                  SizedBox(height: 20),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1,
                  ),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xFF4B0D07)),
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

                      bool shouldUpdate = false;

                      if (loadSelectedDiabetesType != 'Editar' &&
                          loadSelectedDiabetesType != currentDiabetesType) {
                        await GetUserData.saveUserDiabetesTypeToFirestore(
                            userId, loadSelectedDiabetesType);
                        shouldUpdate = true;
                      }

                      if (selectedRACDate != null &&
                          selectedRACDate != currentRACDate) {
                        await GetUserData.saveUserBirthDateToFirestore(
                            userId, selectedRACDate);
                        shouldUpdate = true;
                      }

                      if (selectedFundoscopiaDate != null &&
                          selectedFundoscopiaDate != currentFundoscopiaDate) {
                        await GetUserData.saveUserFundoscopiaDateToFirestore(
                            userId, selectedFundoscopiaDate);
                        shouldUpdate = true;
                      }

                      if (shouldUpdate) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dados atualizados com sucesso!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        context.go('/profilePage');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nenhum dado foi alterado.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      context.go('/profilePage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD8A9A9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(250, 54),
                    ),
                    child: Text(
                      'Salvar',
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
