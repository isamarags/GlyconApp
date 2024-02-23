// services/saveDataFirestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseFunctions {
  static List<Map<String, dynamic>> glucoseData = [];
  static List<Map<String, dynamic>> insulinData = [];
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // static void saveDataToFirestore({
  //   // outros parâmetros,
  //   required String type, // Adicione um parâmetro para distinguir entre glicose e insulina
  // }) async {
  //   try {
  //     final CollectionReference collection = _firestore.collection('dados'); // Substitua 'dados' pelo seu nome de coleção

  //     Map<String, dynamic> data = {
  //       'dateTime': DateTime.now(),
  //     };

  //     // Adicione os dados à coleção correta com base no tipo (glicose ou insulina)
  //     if (type == 'glicose') {
  //       await collection.doc('glicose').collection('glicose').add(data);
  //       glucoseData.add(data); // Adiciona os dados à lista local de glicose
  //     } else if (type == 'insulina') {
  //       await collection.doc('insulina').collection('insulina').add(data);
  //       insulinData.add(data); // Adiciona os dados à lista local de insulina
  //     }
  //   } catch (e) {
  //     print('Erro ao salvar os dados no Firestore: $e');
  //   }
  // }

  // save glucose
  static Future<void> saveGlucoseToFirestore({
    required DateTime selectedDate,
    required String glucoseLevel,
    required bool beforeMealSelected,
    required bool afterMealSelected,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('glicemia').doc(userId).collection('glicose').add({
        'selectedDate': selectedDate,
        'glucoseLevel': glucoseLevel,
        'beforeMealSelected': beforeMealSelected,
        'afterMealSelected': afterMealSelected,
      });
    } catch (e) {
      print('Erro ao salvar dados de glicose no Firestore: $e');
    }
  }
  // save collection insulin
  static Future<void> saveInsulinDataToFirestore({
    required DateTime selectedDate,
    required String insulinValue,
    required bool beforeMealSelected,
    required bool afterMealSelected,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('insulina').add({
        'selectedDate': selectedDate,
        'insulinValue': insulinValue,
        'beforeMealSelected': beforeMealSelected,
        'afterMealSelected': afterMealSelected,
      });
    } catch (e) {
      print('Erro ao salvar dados de insulina no Firestore: $e');
    }
  }

  //save collection pill

  static Future<void> savePillDataToFirestore({
    required DateTime selectedDate,
    required String namePill,
    required int quantityPill,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('medicamento').add({
        'selectedDate': selectedDate,
        'namePill': namePill,
        'quantityPill': quantityPill
      });
    } catch (e) {
      print('Erro ao salvar dados de insulina no Firestore: $e');
    }
  }

  // obter glucose
  static Future<Map<String, dynamic>> getLatestGlucoseDataFromFirestore(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('glicemia')
          .doc(userId)
          .collection('glicose')
          .orderBy('selectedDate', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> glucoseData = docSnapshot.data() as Map<String, dynamic>;
        return glucoseData;
      } else {
        return {}; 
      }
    } catch (e) {
      print('Error getting latest glucose data: $e');
      return {};
    }
  }

  // obter insulina
  static Future<List<Map<String, dynamic>>> getInsulinDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('insulina').get();
      List<Map<String, dynamic>> insulinData = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; 
        insulinData.add(data);
      });
      return insulinData;
    } catch (e) {
      print('Erro ao obter os dados de insulina do Firestore: $e');
      return [];
    }
  }

  // save user data
  static Future<void> saveUserNameToFirestore(String userId, String name) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullName': name,
      });
    } catch (e) {
      print('Erro ao salvar o nome do usuário no Firestore: $e');
    }
  }

  // get user name

  static Future<String> getUserNameFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          String fullName = userData['fullName'] ?? '';
          if (fullName.isNotEmpty) {
            List<String> names = fullName.split(' ');
            return names.first;
          }
        }
      }
      return ''; 
    } catch (e) {
      print('Erro ao obter o nome do usuário do Firestore: $e');
      return '';
    }
  }

  static Future<String> getUserIdFromFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        throw Exception("Nenhum usuário autenticado encontrado");
      }
    } catch (e) {
      print('Erro ao obter o ID do usuário do Firestore: $e');
      return '';
    }
  }

}
