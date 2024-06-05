import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/BuildHealthItem.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart' as firebaseService;
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:glycon_app/services/getUserName.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ViewHistory extends StatefulWidget {
  final String? newGlucoseValue;
  String? glucoseValue;
  final String? newPillValue;
  String? pillValue;
  final String? newFoodValue;
  String? foodValue;
  final String? newInsulinValue;
  String? insulinValue;

  ViewHistory({
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
  _ViewHistoryState createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  int _selectedIndex = 4;
  int _currentPage = 1;
  bool isLoading = false;
  bool _showHistory = true;
  String _userName = '';
  String _userId = '';
  List<Map<String, dynamic>> userRecords = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadLatestGlucoseData();
    _loadUserData();
    fetchUserRecords(_currentPage);
  }

  Future<void> _loadLatestGlucoseData() async {
    String userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();
    Map<String, dynamic>? glucoseData = await firebaseService.FirebaseFunctions
        .getLatestGlucoseDataFromFirestore(userId);
    String glucoseLevelString = glucoseData!['glucoseLevel'];
    int glucoseLevel = int.tryParse(glucoseLevelString) ?? 0;
    setState(() {
      widget.glucoseValue = glucoseLevel.toString();
    });
  }

  Future<void> fetchUserRecords(int pageNumber, {int limit = 15}) async {
    var userId =
        await firebaseService.FirebaseFunctions.getUserIdFromFirestore();

    try {
      List<Map<String, dynamic>> allRecords = [];

      DateTime endDate =
          DateTime.now().subtract(Duration(days: (pageNumber - 1) * 15));
      DateTime startDate = endDate.subtract(Duration(days: 15));

      await loadPage(startDate, endDate, userId, allRecords, limit);

      allRecords.sort((a, b) => (b['selectedDate'] as Timestamp)
          .compareTo(a['selectedDate'] as Timestamp));

      setState(() {
        if (pageNumber == 1) {
          userRecords.clear();
        }
        userRecords.addAll(allRecords);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user records: $e');
    }
  }

  Future<void> loadPage(DateTime startDate, DateTime endDate, String userId,
      List<Map<String, dynamic>> allRecords, int limit) async {
    for (DateTime date = endDate;
        date.isAfter(startDate) || date.isAtSameMomentAs(startDate);
        date = date.subtract(Duration(days: 1))) {
      List<Map<String, dynamic>> glucoseData =
          await firebaseService.FirebaseFunctions.getGlucoseDataFromFirestore(
              userId, date);
      List<Map<String, dynamic>> insulinData =
          await firebaseService.FirebaseFunctions.getInsulinDataFromFirestore(
              userId, date);
      List<Map<String, dynamic>> pillData =
          await firebaseService.FirebaseFunctions.getPillDataFromFirestore(
              userId, date);
      List<Map<String, dynamic>> foodData =
          await firebaseService.FirebaseFunctions.getFoodDataFromFirestore(
              userId, date);

      List<Map<String, dynamic>> recordsForDate = [
        ...glucoseData,
        ...insulinData,
        ...pillData,
        ...foodData
      ];

      recordsForDate.sort((a, b) => (b['selectedDate'] as Timestamp)
          .compareTo(a['selectedDate'] as Timestamp));

      for (var i = 0;
          i < recordsForDate.length && allRecords.length < limit;
          i++) {
        allRecords.add(recordsForDate[i]);
      }

      if (allRecords.length >= limit) {
        break;
      }
    }
  }

  Future<void> _loadUserName() async {
    String userName =
        await GetUserName.getUserNameFromFirestore();
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
  Widget build(BuildContext context) {
    String initials = getInitials(_userName);
    Color userBackgroundColor = getColorForUserId(_userId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Registros',
          style: TextStyle(
            color: Color(0xFF4B0D07),
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.only(left: 35),
          onPressed: () => context.go('/profilePage'),
          color: Color(0xFF4B0D07),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserName();
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                SizedBox(height: 30),
                if (_showHistory && userRecords.isNotEmpty) ...[
                  Text(
                    'Histórico de Registros 💊',
                    style: TextStyle(
                      color: Color(0xFF4B0D07),
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, right: 30, left: 30),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: userRecords.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (userRecords.isNotEmpty &&
                              index < userRecords.length) {
                            Map<String, dynamic> record = userRecords[index];
                            String recordType = '';
                            String recordDetails = '';
                            String imagePath = '';
                            Color backgroundColor = Colors.white;

                            if (record.containsKey('glucoseLevel')) {
                              recordType = 'Glicemia';
                              recordDetails =
                                  '${record['glucoseLevel']}\n${record['mealTime']}';
                              backgroundColor = Colors.red;
                            } else if (record.containsKey('insulinValue')) {
                              recordType = 'Insulina';
                              recordDetails =
                                  '${record['insulinType']}\n${record['insulinValue']} UI';
                              imagePath = 'lib/assets/images/insulin.png';
                              backgroundColor = Colors.green;
                            } else if (record.containsKey('namePill')) {
                              recordType = 'Medicamento';
                              recordDetails =
                                  '${record['namePill']}\n${record['quantityPill']} unidades';
                              imagePath = 'lib/assets/images/medication.png';
                              backgroundColor = Colors.blue;
                            } else if (record.containsKey('nameFood')) {
                              recordType = 'Alimentação';
                              recordDetails =
                                  '${record['nameFood']}\n${record['quantityFood']} ${record['typeFood']}';
                              imagePath = 'lib/assets/images/food.png';
                              backgroundColor = Colors.yellow;
                            }

                            Timestamp? timestamp = record['selectedDate'];
                            DateTime dateTime =
                                timestamp?.toDate() ?? DateTime.now();
                            String formattedDateTime =
                                '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                            return BuildHealthItem(
                              title: recordType,
                              description: recordDetails,
                              dateTime: formattedDateTime,
                            );
                          } else {
                            return isLoading
                                ? _buildLoadingIndicator()
                                : Container();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadAllData() async {
    await _loadUserName();
    await _loadUserData();
    await _loadLatestGlucoseData();
    setState(() {});
  }

  Widget _buildLoadingIndicator() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: CircularProgressIndicator(),
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
}
