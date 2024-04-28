import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:glycon_app/Services/FirebaseFunctions.dart';
import 'package:glycon_app/services/getUserData.dart';

class ChangeProfile extends StatefulWidget {
  final double? selectedWeight;

  const ChangeProfile({Key? key, this.selectedWeight}) : super(key: key);

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  TextEditingController weightController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<String> gender = ["Selecionar", "Masculino", "Feminino"];
  String selectedGender = "Selecionar";
  double? selectedHeight;
  double? selectedWeight;

  @override
  void initState() {
    loadUserData();
    print('Selected weight: ${widget.selectedWeight}');
    if (widget.selectedWeight != null) {
      selectedWeight = widget.selectedWeight;
    }
    super.initState();
  }

  void loadUserData() async {
    try {
      String userId = await FirebaseFunctions.getUserIdFromFirestore();

      String loadSelectedGender =
          await GetUserData.getUserGenderFromFirestore(userId);
      List<Map<String, dynamic>> heightData =
          await GetUserData.getUserHeightFromFirestore(userId);
      double loadSelectedHeight =
          heightData.isNotEmpty ? heightData[0]['height'].toDouble() : null;
      double loadSelectedWeight =
          await GetUserData.getUserWeightFromFirestore(userId);
      DateTime loadSelectedDate =
          await GetUserData.getUserBirthDateFromFirestore(userId);

      setState(() {
        selectedGender = loadSelectedGender;
        selectedHeight = loadSelectedHeight;
        selectedWeight = loadSelectedWeight;
        selectedDate = loadSelectedDate;
      });
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  void openHeightSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HeightSelectionDialog(
          onHeightChanged: (novaAltura) {
            setState(() {
              selectedHeight = novaAltura;
            });
          },
        );
      },
    );
  }

  void openWeightPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeightPicker(
          selectedWeight: selectedWeight.toString(),
          weightController: weightController,
          onWeightChanged: (newWeight) {
            setState(() {
              selectedWeight = double.parse(newWeight);
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
          onPressed: () => context.go('/profilePage'),
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
                      'Editar dados do perfil',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFF4B0D07),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.justify,
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
                          selectedHeight == null
                              ? 'Selecionar'
                              : (selectedHeight! / 100).toStringAsFixed(
                                  2), // Formatando para centímetros
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
                      } else if (selectedWeight == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione um peso antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else if (selectedHeight == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione uma altura antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else if (selectedDate == DateTime.now()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, selecione uma data de nascimento antes de continuar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        await GetUserData.saveUserGenderToFirestore(
                            userId, selectedGender);
                        await GetUserData.saveUserHeightToFirestore(
                            userId, selectedHeight!);

                        await GetUserData.saveUserWeightToFirestore(
                            userId, selectedWeight!);

                        await GetUserData.saveUserBirthDateToFirestore(
                            userId, selectedDate);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dados atualizados com sucesso!'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        context.go('/profilePage');
                      }
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
