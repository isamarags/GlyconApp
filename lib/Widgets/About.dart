import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:glycon_app/Services/FirebaseFunctions.dart';
import 'package:glycon_app/services/getUserData.dart';

class About extends StatefulWidget {
  final double? selectedWeight;
  final double? selectedHeight;

  const About({Key? key, this.selectedWeight, this.selectedHeight})
      : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  TextEditingController weightController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  List<String> gender = ["Selecionar", "Masculino", "Feminino"];
  String selectedGender = "Selecionar";

  double? selectedHeight;

  double? selectedWeight;

  @override
  void initState() {
    selectedWeight = null;
    selectedHeight = null;
    super.initState();
  }

  void openHeightSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HeightSelectionDialog(
          onHeightChanged: (novaAltura) {
            setState(() {});
          },
          initialHeight: selectedHeight ?? 1.60,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedHeight = value.toDouble();
        });
      }
    });
  }

  void openWeightPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeightPicker(
          selectedWeight: selectedWeight,
          weightController: weightController,
          onWeightChanged: (newWeight) {
            setState(() {});
          },
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedWeight = value;
        });
      }
    });
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
          onPressed: () => context.go('/'),
          color: Color(0xFF4B0D07),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
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
                      'Informações pessoais',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Color(0xFF4B0D07)),
                          SizedBox(width: 10),
                          Text(
                            'Genero',
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
                          Text(
                            'Data de nascimento',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFFB98282),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                          Icon(Icons.fitness_center, color: Color(0xFF4B0D07)),
                          SizedBox(width: 10),
                          Text(
                            'Peso (kg)',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFFB98282),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => openWeightPicker(context),
                        child: Text(
                          selectedWeight == null
                              ? 'Selecionar'
                              : selectedWeight.toString(),
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 16,
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
                          Icon(Icons.height, color: Color(0xFF4B0D07)),
                          SizedBox(width: 10),
                          Text(
                            'Altura (cm)',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFFB98282),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => openHeightSelectionDialog(context),
                        child: Text(
                          selectedHeight == null
                              ? 'Selecionar'
                              : selectedHeight!.toStringAsFixed(2),
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () async {
                      String userId =
                          await FirebaseFunctions.getUserIdFromFirestore();

                      if (selectedGender == "Selecionar") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione um gênero antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else if (selectedWeight == null ||
                          selectedWeight == 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione um peso antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else if (selectedHeight == null ||
                          selectedHeight == 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione uma altura antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else if (selectedDate == null ||
                          selectedDate.day == DateTime.now().day) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione uma data de nascimento antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else {
                        await GetUserData.saveUserGenderToFirestore(
                            userId, selectedGender);
                        await GetUserData.saveUserHeightToFirestore(
                            userId, selectedHeight!.toDouble());
                        await GetUserData.saveUserWeightToFirestore(
                            userId, selectedWeight!);
                        await GetUserData.saveUserBirthDateToFirestore(
                            userId, selectedDate);

                        context.go('/health');
                      }

                      // if (selectedGender == "Editar") {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //           'Por favor, selecione um gênero antes de continuar'),
                      //       duration: Duration(seconds: 2),
                      //     ),
                      //   );
                      //   return;
                      // } else if (selectedWeight == null ||
                      //     selectedWeight == 0.0) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //           'Por favor, selecione um peso antes de continuar'),
                      //       duration: Duration(seconds: 2),
                      //     ),
                      //   );
                      //   return;
                      // } else if (selectedHeight == null ||
                      //     selectedHeight == 0.0) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //           'Por favor, selecione uma altura antes de continuar'),
                      //       duration: Duration(seconds: 2),
                      //     ),
                      //   );
                      //   return;
                      // } else if (selectedDate == null ||
                      //     selectedDate.day == DateTime.now().day) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //           'Por favor, selecione uma data de nascimento antes de continuar'),
                      //       duration: Duration(seconds: 2),
                      //     ),
                      //   );
                      //   return;
                      // } else {
                      //   await GetUserData.saveUserGenderToFirestore(
                      //       userId, selectedGender);
                      //   await GetUserData.saveUserHeightToFirestore(
                      //       userId, selectedHeight!.toDouble());
                      //   await GetUserData.saveUserWeightToFirestore(
                      //       userId, selectedWeight!);
                      //   await GetUserData.saveUserBirthDateToFirestore(
                      //       userId, selectedDate);

                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('Dados atualizados com sucesso!'),
                      //       duration: Duration(seconds: 2),
                      //     ),
                      //   );

                      //   context.go('/profilePage');
                      // }
                      // },
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
          ],
        ),
      ),
    );
  }
}
