import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;
import 'package:glycon_app/services/bottomNavigation.dart';
import 'package:glycon_app/services/getUserData.dart';
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ProfilePage extends StatefulWidget {
  final String? newGlucoseValue;
  String? glucoseValue;
  final String? newPillValue;
  String? pillValue;
  final String? newFoodValue;
  String? foodValue;
  final String? newInsulinValue;
  String? insulinValue;

  ProfilePage({
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

  void navigateToPage(int index) {
    _ProfilePageState().navigateToPage(index);
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;
  bool isLoading = false;
  String _userName = '';
  String _userId = '';
  String _userGender = '';
  String _userAge = '';
  String _userDiabetesType = '';

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
    _loadUserName();
    _getUserGenderFromFirestore();
    _getUserAgeFromFirestore();
    _getUserDiabetesTypeFromFirestore();
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
              navigateToPage(4);
            },
          );
        },
      );
    } catch (e) {
      print('Erro ao obter o userId do Firestore: $e');
    }
  }

  Future<void> _getUserGenderFromFirestore() async {
    try {
      String userId =
          await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
      String userGender = await GetUserData.getUserGenderFromFirestore(userId);
      setState(() {
        _userGender = userGender;
      });
    } catch (e) {
      print('Erro ao obter o gênero do usuário: $e');
    }
  }

  // retornar a idade do usuário
  Future<void> _getUserAgeFromFirestore() async {
    try {
      String userId =
          await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
      int userAge = await GetUserData.getUserAgeFromFirestore(userId);
      setState(() {
        _userAge = userAge.toString();
      });
    } catch (e) {
      print('Erro ao obter a idade do usuário: $e');
    }
  }

  // retornar tipo de diabetes do usuario
  Future<void> _getUserDiabetesTypeFromFirestore() async {
    try {
      String userId =
          await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
      String userDiabetesType =
          await GetUserData.getUserDiabetesTypeFromFirestore(userId);
      setState(() {
        _userDiabetesType = userDiabetesType;
      });
    } catch (e) {
      print('Erro ao obter o tipo de diabetes do usuário: $e');
    }
  }

  Future<void> _loadAllData() async {
    await _loadUserName();
    await _loadUserData();
    await _getUserGenderFromFirestore();
    await _getUserAgeFromFirestore();
    await _getUserDiabetesTypeFromFirestore();
  }

  void navigateToPage(int index) {
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
    navigateToPage(index);
    return null;
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
    String initials = getInitials(_userName);
    Color userBackgroundColor = getColorForUserId(_userId);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'PERFIL',
            style: TextStyle(
              color: Color(0xFF4B0D07),
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Color(0x54D8A9A9),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadUserName();
          },
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    color: Color(0x54D8A9A9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 55, right: 25, bottom: 40, top: 25),
                          child: Initicon(
                            text: initials,
                            backgroundColor: userBackgroundColor,
                            size: 70,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  _userName ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF4B0D07),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${_userGender ?? ''}, ${_userAge != null ? _userAge + ' anos' : 'Idade'}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF808080),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${_userDiabetesType != null ? (_userDiabetesType == 'Gestacional' ? 'Diabetes ' + _userDiabetesType : 'Diabetes tipo ' + _userDiabetesType) : ''}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF808080),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50, top: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Detalhes pessoais',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF4B0D07),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFF4B0D07),
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Perfil',
                                        style: GoogleFonts.montserrat(
                                            color: Color(0xFF4B0D07),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      Text(
                                        'Nome, idade, gênero...',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFF808080),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4B0D07),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.2,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.bloodtype_sharp,
                                      color: Color(0xFF4B0D07),
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Saúde',
                                        style: GoogleFonts.montserrat(
                                            color: Color(0xFF4B0D07),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      Text(
                                        'Tipo de diabetes, medicamentos...',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFF808080),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4B0D07),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Configurações',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF4B0D07),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.safety_check,
                                      color: Color(0xFF4B0D07),
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Segurança',
                                        style: GoogleFonts.montserrat(
                                            color: Color(0xFF4B0D07),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      Text(
                                        'Alterar senha ou e-mail',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFF808080),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4B0D07),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.2,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.document_scanner,
                                      color: Color(0xFF4B0D07),
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Termos de uso',
                                        style: GoogleFonts.montserrat(
                                            color: Color(0xFF4B0D07),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      Text(
                                        'Leia nossos termos de uso',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFF808080),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4B0D07),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.2,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.logout,
                                      color: Color(0xFF4B0D07),
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sair',
                                        style: GoogleFonts.montserrat(
                                            color: Color(0xFF4B0D07),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      Text(
                                        'Sair da conta',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFF808080),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      GetUserData.signOut(context);
                                      GoRouter.of(context).go('/login');
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4B0D07),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.2,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Color(0xFF4B0D07),
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delete a sua conta',
                                        style: GoogleFonts.montserrat(
                                            color: Color(0xFF4B0D07),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      Text(
                                        'Apagar todos os dados',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFF808080),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4B0D07),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex,
          onNavigationItemSelected: _onNavigationItemSelected,
        ));
  }
}
