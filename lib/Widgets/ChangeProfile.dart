import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:glycon_app/Services/FirebaseFunctions.dart';
import 'package:glycon_app/services/getUserData.dart';
// import 'package:glycon_app/services/updateUserData.dart';

class ChangeProfile extends StatefulWidget {
  final double? selectedWeight;

  const ChangeProfile({Key? key, this.selectedWeight}) : super(key: key);

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  TextEditingController weightController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime currentBirthDate = DateTime.now();
  List<String> gender = ["Editar", "Masculino", "Feminino"];
  late String loadSelectedGender = "Editar";
  String selectedGender = '';
  String currentGender = '';
  double? selectedHeight;
  double? selectedWeight;
  double? currentHeight;
  double? currentWeight;
  String currentName = '';

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  void loadUserData() async {
    try {
      String userId = await FirebaseFunctions.getUserIdFromFirestore();

      String currentName = await FirebaseFunctions.getUserNameFromFirestore();
      nameController.text = currentName;

      String currentGender =
          await GetUserData.getUserGenderFromFirestore(userId);
      double currentHeight =
          await GetUserData.getUserHeightFromFirestore(userId);
      double currentWeight =
          await GetUserData.getUserWeightFromFirestore(userId);
      DateTime currentBirthDate =
          await GetUserData.getUserBirthDateFromFirestore(userId);

      setState(() {
        loadSelectedGender = currentGender;
        selectedGender = currentGender;
        selectedHeight = currentHeight;
        selectedWeight = currentWeight;
        selectedDate = currentBirthDate;
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
                  SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Color(0xFF4B0D07)),
                          SizedBox(width: 10),
                          Text(
                            'Nome',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFFB98282),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: nameController,
                          onSubmitted: (newName) async {
                            String userId = await FirebaseFunctions
                                .getUserIdFromFirestore();
                            String currentName = await FirebaseFunctions
                                .getUserNameFromFirestore();
                            nameController.text = currentName;

                            if (newName != null && newName.isNotEmpty) {
                              await FirebaseFunctions.saveUserNameToFirestore(
                                  userId, newName);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Alterar',
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
                        value: loadSelectedGender,
                        onChanged: (String? newGender) {},
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
                              ? 'Editar'
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
                              ? 'Editar'
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

                      bool shouldUpdate = false;

                      // Verificar e atualizar o nome
                      if (nameController.text.isNotEmpty &&
                          nameController.text != currentName) {
                        await FirebaseFunctions.saveUserNameToFirestore(
                            userId, nameController.text);
                        shouldUpdate = true;
                      }

                      // Verificar e atualizar o gênero
                      if (loadSelectedGender != 'Editar' &&
                          loadSelectedGender != currentGender) {
                        await GetUserData.saveUserGenderToFirestore(
                            userId, loadSelectedGender);
                        shouldUpdate = true;
                      }

                      // Verificar e atualizar o peso
                      if (selectedWeight != null &&
                          selectedWeight != currentWeight) {
                        await GetUserData.saveUserWeightToFirestore(
                            userId, selectedWeight!);
                        shouldUpdate = true;
                      }

                      // Verificar e atualizar a altura
                      if (selectedHeight != null &&
                          selectedHeight != currentHeight) {
                        await GetUserData.saveUserHeightToFirestore(
                            userId, selectedHeight!);
                        shouldUpdate = true;
                      }

                      // Verificar e atualizar a data de nascimento
                      if (selectedDate != null &&
                          selectedDate != currentBirthDate) {
                        await GetUserData.saveUserBirthDateToFirestore(
                            userId, selectedDate);
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
