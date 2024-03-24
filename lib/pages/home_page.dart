import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:glycon_app/Widgets/BuildHealthItem.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;

class LandingPage extends StatefulWidget {

  final String? newGlucoseValue;
  String? glucoseValue;
  final String? newPillValue;
  String? pillValue;
  final String? newFoodValue;
  String? foodValue;
  final String? newInsulinValue;
  String? insulinValue;

  LandingPage({
    Key? key,
    required this.glucoseValue,
    required this.newGlucoseValue,
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
              await _loadLatestGlucoseData();
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
              _navigateToPage(0);
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

  void _navigateToPage(int index) {
    final router = GoRouter.of(context);

    switch (index) {
      case 0:
        router.go('/homePage');
        break;
      case 1:
        router.go('/metas');
        break;
      case 2:
        _showSlidingUpPanel();
        break;
      case 3:
        router.go('/charts');
        break;
      case 4:
        router.go('/profilePage');
        break;
    }
  }

  void Function(int)? _onNavigationItemSelected(int index) {
    _navigateToPage(index);
    return null;
  }

  BottomNavigationBarItem _buildIcon(int index, IconData icon, String label) {
    final customItem = CustomBottomNavigationBarItem(
      index: index,
      icon: icon,
      label: label,
      selectedIndex: _selectedIndex,
      onTap: () => _onNavigationItemSelected(index),
    );

    return BottomNavigationBarItem(
      icon: Icon(customItem.icon),
      label: customItem.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseService.FirebaseFunctions.getUserNameFromFirestore(),
      builder: (context, snapshot) {
        String? userName = snapshot.data;
        _userName = userName ?? '';
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              await _loadUserName();
              await _loadUserData();
              await _loadLatestGlucoseData();
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
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('lib/assets/images/avatar.png'),
                                radius: 30,
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
                              //     onPressed: () {},
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

                                  bool withinRange =
                                      glucoseLevel >= 70 && glucoseLevel <= 180;

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

                                  return Container(
                                    width: 217,
                                    height: 120,
                                    margin: EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xFFD8A9A9),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Glicose',
                                          style: TextStyle(
                                            color: Color(0xFF4B0D07),
                                            fontFamily: 'Montserrat',
                                            fontSize: 25,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: textColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
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

                                Timestamp timestamp =
                                    data['selectedDate'] ?? Timestamp.now();
                                DateTime dateTime = timestamp.toDate();

                                String formattedDateTime =
                                    '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                return BuildHealthItem(
                                  imagePath: 'lib/assets/images/medication.png',
                                  title: 'Medicamento',
                                  description: data['namePill'],
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
                            future: firebaseService.FirebaseFunctions.getLastInsulinDataFromFirestore(_userId),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Erro: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
                                // Retorna BuildHealthItem vazio se não houver dados
                                return BuildHealthItem(
                                  title: 'Insulina',
                                  imagePath: 'lib/assets/images/insulin.png',
                                  description: '',
                                  backgroundColor: Colors.green,
                                  dateTime: '',
                                );
                              } else {
                                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                                Timestamp timestamp = data['selectedDate'] ?? Timestamp.now();
                                DateTime dateTime = timestamp.toDate();

                                String formattedDateTime = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                return BuildHealthItem(
                                  imagePath: 'lib/assets/images/insulin.png',
                                  title: 'Insulina',
                                  description: data['insulinValue'],
                                  backgroundColor: Colors.green,
                                  dateTime: formattedDateTime,
                                );
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

                                Timestamp timestamp =
                                    data['selectedDate'] ?? Timestamp.now();
                                DateTime dateTime = timestamp.toDate();

                                String formattedDateTime =
                                    '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                String foodDescription = data['nameFood'];
                                double foodQuantity = data['quantityFood'] ?? 0;
                                String foodType = data['typeFood'];

                                String description = foodType == 'grama'
                                    ? '$foodDescription - ${foodQuantity.toString()} gramas'
                                    : '$foodDescription - ${foodQuantity.toString()} unidades';

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
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: null,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _navigateToPage,
              type: BottomNavigationBarType.fixed,
              items: [
                _buildIcon(0, Icons.home, 'Home'),
                _buildIcon(1, Icons.star, 'Metas'),
                _buildIcon(2, Icons.equalizer, 'Registrar'),
                _buildIcon(3, Icons.share, 'Relatórios'),
                _buildIcon(4, Icons.person, 'Conta'),
              ],
            ),
          ),
        );
      },
    );
  }
}
