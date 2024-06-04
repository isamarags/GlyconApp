import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';

class NavigationBar extends StatefulWidget {
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

  final int currentIndex;

  NavigationBar({
    Key? key,
    this.glucoseValue,
    this.newGlucoseValue,
    this.pillValue,
    this.newPillValue,
    this.foodValue,
    this.newFoodValue,
    this.insulinValue,
    this.newInsulinValue,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  String _userName = '';
  String _userId = '';
  int _selectedIndex = 1;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);
    _selectedIndex = widget.currentIndex;
    _loadUserName();
    _loadUserData();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _userId = userId;
    } else {
      print('Erro ao obter o userId do usuário');
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

  Future<void> _loadAllData() async {
    await _loadUserName();
    await _loadUserData();
    await _loadLatestGlucoseData();
    await _loadLatestInsulinData();
    await _loadLatestFoodData();
    await _loadLatestMedicationData();
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
            onClose: () async {
              await _loadAllData();
              setState(() {});
              Navigator.pop(context);
            },
          );
        },
      );
    } catch (e) {
      print('Erro ao obter o userId do Firestore: $e');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _router.go('/homePage');
        break;
      case 1:
        _showSlidingUpPanel();
        break;
      case 2:
        _router.go('/charts');
        break;
      case 3:
        _router.go('/profilePage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFAA7474),
        unselectedItemColor: Color(0xFFE0BBAB),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            label: 'Registrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conta',
          ),
        ],
        onTap: _navigateToPage);
  }
}
