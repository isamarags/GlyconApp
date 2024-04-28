import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/GestureDetectorProfile.dart';
import 'package:glycon_app/Widgets/DeleteConfirmationDialog.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;
import 'package:glycon_app/services/getUserData.dart';
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
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
  int _selectedIndex = 3;
  bool isLoading = false;
  String _userName = '';
  String _userId = '';
  String _userGender = '';
  String _userAge = '';
  String _userDiabetesType = '';
  BuildContext? _dialogContext;

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

  void _showDeleteConfirmationDialog(BuildContext context) {
    _dialogContext = context; // Armazena o BuildContext do modal
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          onDeleteConfirmed: () async {
            await GetUserData.deleteAccount(
                _dialogContext!); // Usa o BuildContext armazenado
          },
        );
      },
    );
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
        _showSlidingUpPanel();
        break;
      case 2:
        router.go('/charts');
        break;
      case 3:
        router.go('/profilePage');
        break;
    }
  }

  void Function(int)? _onNavigationItemSelected(int index) {
    navigateToPage(index);
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
                            buildRowItem(
                              icon: Icons.person,
                              title: 'Perfil',
                              subtitle: 'Nome, idade, gênero...',
                              onTap: () {
                                context.go('/changeProfile');
                              },
                            ),
                            SizedBox(height: 8),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                            SizedBox(height: 8),
                            buildRowItem(
                                icon: Icons.bloodtype,
                                title: 'Saúde',
                                subtitle: 'Tipo de diabetes, medicamentos...',
                                onTap: () {}),
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
                            buildRowItem(
                                icon: Icons.security,
                                title: 'Segurança',
                                subtitle: 'Alterar senha ou e-mail',
                                onTap: () {}),
                            SizedBox(height: 8),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                            SizedBox(height: 8),
                            buildRowItem(
                                icon: Icons.edit_document,
                                title: 'Termos',
                                subtitle: 'Leia nossos termos de uso',
                                onTap: () {}),
                            SizedBox(height: 8),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                            SizedBox(height: 8),
                            buildRowItem(
                                icon: Icons.logout,
                                title: 'Sair',
                                subtitle: 'Sair da sua conta',
                                onTap: () async {
                                  await GetUserData.signOut(context);
                                }),
                            SizedBox(height: 8),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                            SizedBox(height: 8),
                            buildRowItem(
                                icon: Icons.delete_forever,
                                title: 'Deletar conta',
                                subtitle: 'Apagar todos os seus dados',
                                onTap: () async {
                                  _showDeleteConfirmationDialog(context);
                                }),
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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: null,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: navigateToPage,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildIcon(0, Icons.home, 'Home'),
            _buildIcon(1, Icons.equalizer, 'Registrar'),
            _buildIcon(2, Icons.share, 'Relatórios'),
            _buildIcon(3, Icons.person, 'Conta'),
          ],
        ),
      ),
    );
  }
}
