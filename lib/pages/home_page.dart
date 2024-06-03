import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:glycon_app/Widgets/BuildHealthItem.dart';
import 'package:glycon_app/Widgets/BuildHealthItemGlucose.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:random_color/random_color.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/Widgets/NavigationBar.dart' as Navigation;

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:glycon_app/pages/HomePageChart.dart';
import 'package:glycon_app/pages/profile_page.dart';

class LandingPage extends StatefulWidget {
  final String? newGlucoseValue;
  String? glucoseValue;
  final String? newPillValue;
  String? pillValue;
  final String? newFoodValue;
  String? foodValue;
  final String? newInsulinValue;
  String? insulinValue;
  int? quantityPill;
  int? quantityFood;
  String? insulinType;

  LandingPage({
    Key? key,
    this.glucoseValue,
    this.newGlucoseValue,
    this.pillValue,
    this.newPillValue,
    this.foodValue,
    this.newFoodValue,
    this.insulinValue,
    this.newInsulinValue,
  }) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  String _greeting = '';
  String _userName = '';
  String _userId = '';
  bool _firstTimeUser = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  RandomColor _randomColor = RandomColor();

  void _setGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 5) {
      _greeting = 'Boa noite';
    } else if (hour >= 5 && hour < 12) {
      _greeting = 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      _greeting = 'Boa tarde';
    } else {
      _greeting = 'Boa noite';
    }
  }

  Future<void> _loadUserName() async {
    String userName =
        await firebaseService.FirebaseFunctions.getUserNameFromFirestore();
    setState(() {
      _userName = userName;
    });
  }

  Future<void> _loadUserData() async {
    String userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    setState(() {
      _userId = userId;
    });
  }

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _loadUserName();
    _loadUserData();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _userId = userId;
    } else {
      print('Erro ao obter o userId do usuário');
    }
  }

  void _showSlidingUpPanel() async {
    try {
      String userId =
          await firebaseService.FirebaseFunctions.getUserIdFromFirestore();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AddOptionsPanel(
            userId: userId,
            onDataRegistered: () async {
              await _loadAllData();
              Navigator.pop(context);
            },
            glucoseValue: widget.glucoseValue,
            newGlucoseValue: widget.newGlucoseValue,
            newPillValue: widget.newPillValue,
            pillValue: widget.pillValue,
            newFoodValue: widget.newFoodValue,
            foodValue: widget.foodValue,
            newInsulinValue: widget.newInsulinValue,
            insulinValue: widget.insulinValue,
            onClose: () {
              Navigator.pop(context);
            },
          );
        },
      );
    } catch (e) {
      print('Erro ao obter o userId do Firestore: $e');
    }
  }

  Future<void> _loadLatestGlucoseData() async {
    String userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    Map<String, dynamic>? glucoseData = await firebaseService.FirebaseFunctions
        .getLatestGlucoseDataFromFirestore(userId);
    String glucoseLevelString = glucoseData['glucoseLevel'];
    int glucoseLevel = int.tryParse(glucoseLevelString) ?? 0;
    setState(() {
      widget.glucoseValue = glucoseLevel.toString();
    });
  }

  Future<void> _loadLatestInsulinData() async {
    String userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    Map<String, dynamic>? insulinData = await firebaseService.FirebaseFunctions
        .getLatestInsulinDataFromFirestore(userId);
    String insulinValue = insulinData['insulinValue'];
    String insulinType = insulinData['insulinType'];
    setState(() {
      widget.insulinValue = insulinValue.toString();
      widget.insulinType = insulinType.toString();
    });
  }

  Future<void> _loadLatestMedicationData() async {
    String userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    DocumentSnapshot? medicationData =
        await firebaseService.FirebaseFunctions.getLastPillDataFromFirestore(
            userId);
    String namePill = medicationData['namePill'];
    int quantityPill = medicationData['quantityPill'];
    setState(() {
      widget.pillValue = namePill;
      widget.quantityPill = quantityPill;
    });
  }

  Future<void> _loadLatestFoodData() async {
    String userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    DocumentSnapshot? foodData =
        await firebaseService.FirebaseFunctions.getLastFoodDataFromFirestore(
            userId);
    String nameFood = foodData!['nameFood'];
    int foodQuantity = foodData['quantityFood'];
    setState(() {
      widget.foodValue = nameFood;
      widget.quantityFood = foodQuantity;
    });
  }

  Future<void> _loadAllData() async {
    await _loadUserName();
    await _loadUserData();
    await _loadLatestGlucoseData();
    await _loadLatestInsulinData();
    await _loadLatestFoodData();
    await _loadLatestMedicationData();
  }

  String getInitials(String fullName) {
    List<String> names = fullName.split(' ');
    String initials = '';
    int numWords = 2;

    if (names.length >= numWords) {
      for (int i = 0; i < numWords; i++) {
        initials += names[i][0].toUpperCase();
      }
    } else {
      for (int i = 0; i < names.length; i++) {
        initials += names[i][0].toUpperCase();
      }
    }

    return initials;
  }

  Color getColorForUserId(String userId) {
    List<int> bytes = utf8.encode(userId);

    Digest md5Hash = md5.convert(bytes);
    String hexHash = md5Hash.toString();

    int r = int.parse(hexHash.substring(0, 2), radix: 16);
    int g = int.parse(hexHash.substring(2, 4), radix: 16);
    int b = int.parse(hexHash.substring(4, 6), radix: 16);

    return Color.fromRGBO(r, g, b, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseService.FirebaseFunctions.getUserNameFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return RefreshIndicator(
            child: SingleChildScrollView(),
            onRefresh: () async {
              await _loadUserName();
              await _loadUserData();
              await _loadLatestGlucoseData();
              await _loadLatestInsulinData();
              await _loadLatestFoodData();
              await _loadLatestMedicationData();
            },
          );
        } else {
          String? userName = snapshot.data;
          _userName = userName ?? '';
          String initials = getInitials(_userName);
          String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
          Color userBackgroundColor = getColorForUserId(userId);
          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                await _loadUserName();
                await _loadUserData();
                await _loadLatestGlucoseData();
                await _loadLatestInsulinData();
                await _loadLatestFoodData();
                await _loadLatestMedicationData();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Initicon(
                                  text: initials,
                                  backgroundColor: userBackgroundColor,
                                  size: 50,
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userName ?? '',
                                      style: TextStyle(
                                        color: Color(0xFFB98282),
                                        fontFamily: 'Montserrat',
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      _greeting,
                                      style: TextStyle(
                                        color: Color(0xFF4B0D07),
                                        fontFamily: 'Montserrat',
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // Grade de menu
                                // Spacer(),
                                // Container(
                                //   padding: EdgeInsets.only(right: 20),
                                //   child: IconButton(
                                //     icon: Icon(Icons.menu),
                                //     iconSize: 40,
                                //     color: Color(0xFF4B0D07),
                                //     onPressed: () => context.go('/menu'),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            FutureBuilder<Map<String, dynamic>?>(
                              future: firebaseService.FirebaseFunctions
                                  .getLatestGlucoseDataFromFirestore(_userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Erro ao carregar os dados: ${snapshot.error}');
                                } else {
                                  Map<String, dynamic>? glucoseData =
                                      snapshot.data;
                                  if (glucoseData != null) {
                                    String glucoseLevelString =
                                        glucoseData['glucoseLevel'];
                                    int glucoseLevel =
                                        int.tryParse(glucoseLevelString) ?? 0;

                                    bool withinRange = glucoseLevel >= 70 &&
                                        glucoseLevel <= 180;

                                    String message = withinRange
                                        ? '👍 $glucoseLevel mg/dl'
                                        : '👎 $glucoseLevel mg/dl';
                                    Color textColor = withinRange
                                        ? Color(0xFF3F7332)
                                        : Color(0xFFFF0000);

                                    if (_firstTimeUser && glucoseLevel == 0) {
                                      message = 'Nenhum dado registrado';
                                      textColor = Colors.black;
                                    }

                                    return BuildHealthItemGlucose(
                                      title: 'Glicose',
                                      description: message,
                                      backgroundColor: textColor,
                                      dateTime:
                                          glucoseData.containsKey('dateTime')
                                              ? glucoseData['dateTime']
                                              : '',
                                    );
                                  } else {
                                    return Text('Nenhum dado disponível');
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Informações de Saúde 💊',
                                    style: TextStyle(
                                      color: Color(0xFF4B0D07),
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            FutureBuilder<DocumentSnapshot>(
                              future: firebaseService.FirebaseFunctions
                                  .getLastPillDataFromFirestore(_userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  if (data['isPrimary']) {
                                    return BuildHealthItem(
                                      imagePath:
                                          'lib/assets/images/medication.png',
                                      title: 'Medicamento',
                                      description: 'Nenhum dado registrado',
                                      backgroundColor: Colors.blue,
                                      dateTime: '',
                                    );
                                  }

                                  Timestamp timestamp =
                                      data['selectedDate'] ?? Timestamp.now();
                                  DateTime dateTime = timestamp.toDate();

                                  String formattedDateTime =
                                      '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                  int pillQuantity = data['quantityPill'] ?? 0;
                                  String pillName = data['namePill'];

                                  String description =
                                      '$pillName \nQuantidade: ${pillQuantity.toString()} unidades';

                                  print('Pill data: $data');

                                  return BuildHealthItem(
                                    imagePath:
                                        'lib/assets/images/medication.png',
                                    title: 'Medicamento',
                                    description: description,
                                    backgroundColor: Colors.blue,
                                    dateTime: formattedDateTime,
                                  );
                                } else {
                                  return Text(
                                      'Nenhum dado de medicamento encontrado');
                                }
                              },
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: firebaseService.FirebaseFunctions
                                  .getLastInsulinDataFromFirestore(_userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  if (data['isPrimary']) {
                                    return BuildHealthItem(
                                      imagePath:
                                          'lib/assets/images/insulin.png',
                                      title: 'Insulina',
                                      description: 'Nenhum dado registrado',
                                      backgroundColor: Colors.green,
                                      dateTime: '',
                                    );
                                  }
                                  // Verificar se há dados de insulina disponíveis
                                  if (data.isNotEmpty) {
                                    String insulinType =
                                        data['insulinType'] ?? 'Desconhecido';
                                    String insulinValue =
                                        data['insulinValue'] ?? 'Desconhecido';

                                    Timestamp timestamp =
                                        data['selectedDate'] ?? Timestamp.now();
                                    DateTime dateTime = timestamp.toDate();

                                    String formattedDateTime =
                                        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                    return BuildHealthItem(
                                      imagePath:
                                          'lib/assets/images/insulin.png',
                                      title: 'Insulina',
                                      description:
                                          'Tipo: $insulinType\nDosagem: $insulinValue UI',
                                      backgroundColor: Colors.green,
                                      dateTime: formattedDateTime,
                                    );
                                  } else {
                                    return Text(
                                        'Nenhum dado de insulina encontrado');
                                  }
                                } else {
                                  return Text(
                                      'Nenhum dado de insulina encontrado');
                                }
                              },
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: firebaseService.FirebaseFunctions
                                  .getLastFoodDataFromFirestore(_userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  if (data['isPrimary']) {
                                    return BuildHealthItem(
                                      imagePath: 'lib/assets/images/food.png',
                                      title: 'Alimentação',
                                      description: 'Nenhum dado registrado',
                                      backgroundColor: Colors.yellow,
                                      dateTime: '',
                                    );
                                  }

                                  Timestamp timestamp =
                                      data['selectedDate'] ?? Timestamp.now();
                                  DateTime dateTime = timestamp.toDate();

                                  String formattedDateTime =
                                      '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                  String foodDescription = data['nameFood'];
                                  int foodQuantity = data['quantityFood'] ?? 0;
                                  String formattedQuantity =
                                      foodQuantity.toStringAsFixed(1);

                                  String foodType = data['typeFood'];

                                  String description = foodType == 'grama'
                                      ? 'Alimento: $foodDescription \nPeso: ${formattedQuantity} gramas'
                                      : 'Alimento: $foodDescription \nQuantidade: ${formattedQuantity} unidades';

                                  return BuildHealthItem(
                                    imagePath: 'lib/assets/images/food.png',
                                    title: 'Alimentação',
                                    description: description,
                                    backgroundColor: Colors.yellow,
                                    dateTime: formattedDateTime,
                                  );
                                } else {
                                  return Text(
                                      'Nenhum dado de alimentação encontrado');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Navigation.NavigationBar(
              currentIndex: 0,
            ),
          );
        }
      },
    );
  }
}
