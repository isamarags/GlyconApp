import 'package:flutter/material.dart';
// import 'package:glycon_app/pages/home_page.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

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

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;

  void _navigateToPage(index) {
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nome do usuário',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage(
              //     ''), // Adicione a imagem de perfil do usuário aqui
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione a funcionalidade para editar o perfil aqui
              },
              child: Text('Editar Perfil'),
            ),
            ElevatedButton(
              onPressed: () {
                // Adicione a funcionalidade para gerenciar configurações de conta aqui
              },
              child: Text('Configurações de Conta'),
            ),
            ElevatedButton(
              onPressed: () {
                // Adicione a funcionalidade para visualizar o histórico de atividades aqui
              },
              child: Text('Histórico de Atividades'),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Feedback'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
