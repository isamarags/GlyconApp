import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:glycon_app/Widgets/BuildHealthItem.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;


class LandingPage extends StatefulWidget {
  final String? newGlucoseValue;
  String? glucoseValue;
  // final String? newPillValue;
  // String? pillValue;
  LandingPage(
      {Key? key,
      required this.glucoseValue,
      required this.newGlucoseValue,
      // required this.newPillValue,
      // required this.pillValue
      })
      : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  String _greeting = '';
  String _userName = '';
  String _userId = '';
  bool _firstTimeUser = true;


  void _setGreeting() {
    // Obtém a hora atual
    DateTime now = DateTime.now();
    int hour = now.hour;

    // Define a saudação com base na hora do dia
    if (hour > 4 && hour < 12) {
      _greeting = 'Bom dia';
    } else if (hour < 18) {
      _greeting = 'Boa tarde';
    } else {
      _greeting = 'Boa noite';
    }
  }

  Future<void> _loadUserName() async {
    String userName = await firebaseService.FirebaseFunctions.getUserNameFromFirestore();
    setState(() {
      _userName = userName;
    });
  }

  Future<void> _loadUserData() async {
    String userId = await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
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
  }

  void _showReorderOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Text('Opção de reordenar'),
          ),
        );
      },
    );
  }


  void _showSlidingUpPanel() async {
    try {
      // Obtém o userId do Firestore
      String userId = await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
      
      // Exibe o painel deslizante após obter o userId
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
            onClose: () {
              Navigator.pop(context);
              _navigateToPage(0);
            },
          );
        },
      );
    } catch (e) {
      print('Erro ao obter o userId do Firestore: $e');
      // Trate o erro conforme necessário, como exibir uma mensagem de erro ao usuário
    }
  }


  Future<void> _loadLatestGlucoseData() async {
    String userId = await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    Map<String, dynamic>? glucoseData = await firebaseService.FirebaseFunctions.getLatestGlucoseDataFromFirestore(userId);
    String glucoseLevelString = glucoseData['glucoseLevel'];
    int glucoseLevel = int.tryParse(glucoseLevelString) ?? 0;
    setState(() {
      widget.glucoseValue = widget.glucoseValue;
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
        router.go('/relatorios');
        break;
      case 4:
        router.go('/accountPage');
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

  List<Color> backgroundColors = [
    Color(0xFFE7F1FF),
    Color(0xFFDCFFD7),
    Color(0xFFFAD5CD),
  ];

  @override
  Widget build(BuildContext context) {
    // String formattedDateTime =
    //     DateFormat('dd MMMM - HH:mm').format(DateTime.now());

    return FutureBuilder(
      future: firebaseService.FirebaseFunctions.getUserNameFromFirestore(),
      builder: (context, snapshot) {
        String? userName = snapshot.data;
        _userName = userName ?? ''; 
          return Scaffold(
            backgroundColor: Colors.white,
          body: SingleChildScrollView(
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
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(right: 20),
                              child: IconButton(
                                icon: Icon(Icons.menu),
                                iconSize: 40,
                                color: Color(0xFF4B0D07),
                                onPressed: () {},
                              ),
                            ),
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
                              return CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto os dados estão sendo carregados
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Erro ao carregar os dados: ${snapshot.error}');
                            } else {
                              Map<String, dynamic>? glucoseData = snapshot.data;
                              if (glucoseData != null) {
                                String glucoseLevelString = glucoseData[
                                    'glucoseLevel']; // Obtém o valor como uma string
                                int glucoseLevel = int.tryParse(
                                        glucoseLevelString) ??
                                    0; // Converte para um inteiro, ou 0 se a conversão falhar

                                // Verifica se o valor da glicose está dentro dos parâmetros desejados (70 a 180)
                                bool withinRange =
                                    glucoseLevel >= 70 && glucoseLevel <= 180;

                                // Define o texto e a cor com base nos parâmetros
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              // Spacer(),
                              // IconButton(
                              //   icon: Icon(Icons.more_vert),
                              //   onPressed: _showReorderOptions,
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        FutureBuilder(
                          future: firebaseService.FirebaseFunctions
                              .getLatestGlucoseDataFromFirestore(_userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                Map<String, dynamic> glucoseData =
                                    snapshot.data as Map<String, dynamic>;
                                return BuildHealthItem(
                                  key: ValueKey(
                                      'medication'), // Chave única para o item de medicamento
                                  imagePath: 'lib/assets/images/medication.png',
                                  title: 'Medicamentos',
                                  // '${glucoseData['glucoseLevel']} ml/dl',
                                  description: '',
                                  backgroundColor:
                                      Colors.blue, // backgroundColors[0]
                                  dateTime: 'teste', // formattedDateTime
                                );
                              } else {
                                return Text('Nenhum dado disponível');
                              }
                            }
                          },
                        ),
                        FutureBuilder(
                          future: firebaseService.FirebaseFunctions
                              .getLatestGlucoseDataFromFirestore(_userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                Map<String, dynamic> glucoseData =
                                    snapshot.data as Map<String, dynamic>;
                                return BuildHealthItem(
                                  key: ValueKey(
                                      'insulin'), // Chave única para o item de insulina
                                  imagePath: 'lib/assets/images/insulin.png',
                                  title: 'Insulina',
                                  description: 'NPH',
                                  backgroundColor:
                                      Colors.green, // backgroundColors[1],
                                  dateTime: '', // formattedDateTime
                                );
                              } else {
                                return Text('Nenhum dado disponível');
                              }
                            }
                          },
                        ),
                        FutureBuilder(
                          future: firebaseService.FirebaseFunctions
                              .getLatestGlucoseDataFromFirestore(_userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                Map<String, dynamic> glucoseData =
                                    snapshot.data as Map<String, dynamic>;
                                return BuildHealthItem(
                                  key: ValueKey(
                                      'food'), // Chave única para o item de alimentação
                                  imagePath: 'lib/assets/images/food.png',
                                  title: 'Alimentação',
                                  description: '',
                                  backgroundColor:
                                      Colors.yellow, // backgroundColors[2]
                                  dateTime: '', // formattedDateTime
                                );
                              } else {
                                return Text('Nenhum dado disponível');
                              }
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
