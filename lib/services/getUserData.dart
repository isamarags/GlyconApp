import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class GetUserData {
  static Future<void> saveUserWeightToFirestore(
      String userId, double weight) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'weight': weight,
        });
      } else {
        await userDocRef.set({
          'weight': weight,
        });
      }
      print('Peso do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> saveUserHeightToFirestore(
      String userId, double height) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'height': height,
        });
      } else {
        await userDocRef.set({
          'height': height,
        });
      }
      print('Altura do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> saveUserBirthDateToFirestore(
      String userId, DateTime birthDate) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'birthDate': birthDate,
        });
      } else {
        await userDocRef.set({
          'birthDate': birthDate,
        });
      }
      print('Aniversario do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> saveUserGenderToFirestore(
      String userId, String gender) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'gender': gender,
        });
      } else {
        await userDocRef.set({
          'gender': gender,
        });
      }
      print('Genero do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> saveUserDiabetesTypeToFirestore(
      String userId, String diabetesType) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'diabetesType': diabetesType,
        });
      } else {
        await userDocRef.set({
          'diabetesType': diabetesType,
        });
      }
      print('diabetesType do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> saveUserFundoscopiaDateToFirestore(
      String userId, DateTime fundoscopiaDate) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'fundoscopiaDate': fundoscopiaDate,
        });
      } else {
        await userDocRef.set({
          'fundoscopiaDate': fundoscopiaDate,
        });
      }
      print('Fundoscopia do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> saveUserRACDateToFirestore(
      String userId, DateTime RACDate) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'RACDate': RACDate,
        });
      } else {
        await userDocRef.set({
          'RACDate': RACDate,
        });
      }
      print('RAC do usuário salvo com sucesso no Firestore');
    } catch (e) {
      print('Erro ao salvar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<void> getUserWeightFromFirestore(String userId) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return documentSnapshot.get('weight');
    } catch (e) {
      print('Erro ao buscar o peso do usuário no Firestore: $e');
    }
  }
}
