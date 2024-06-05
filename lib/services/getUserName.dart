import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetUserName {
  static Future<String> getUserNameFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          String fullName = userData['fullName'] ?? '';
          if (fullName.isNotEmpty) {
            List<String> names = fullName.split(' ');
            if (names.length > 1) {
              return names.first + ' ' + names.last;
            } else {
              return names.first;
            }
          }
        }
      }
      return '';
    } catch (e) {
      print('Erro ao obter o nome do usuário do Firestore: $e');
      return '';
    }
  }

  static Future<String> getFirstNameFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          String fullName = userData['fullName'] ?? '';
          if (fullName.isNotEmpty) {
            return fullName.split(' ').first;
          }
        }
      }
      return '';
    } catch (e) {
      print('Erro ao obter o nome do usuário do Firestore: $e');
      return '';
    }
  }

  static Future<String> getFullNameFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          String fullName = userData['fullName'] ?? '';
          if (fullName.isNotEmpty) {
            return fullName;
          }
        }
      }
      return '';
    } catch (e) {
      print('Erro ao obter o nome do usuário do Firestore: $e');
      return '';
    }
  }
}
