import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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

  // get diabetes type
  

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

  static Future<DateTime> getUserFundoscopiaDateFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('fundoscopiaDate')) {
          return userData['fundoscopiaDate'].toDate();
        } else {
          print('Fundoscopia do usuário não encontrada');
          return DateTime.now();
        }
      } else {
        print('Documento do usuário não encontrado');
        return DateTime.now();
      }
    } catch (e) {
      print('Erro ao buscar Fundoscopia do usuário no Firestore: $e');
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

  static Future<DateTime> getUserRACDateFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('RACDate')) {
          return userData['RACDate'].toDate();
        } else {
          print('RAC do usuário não encontrado');
          return DateTime.now();
        }
      } else {
        print('Documento do usuário não encontrado');
        return DateTime.now();
      }
    } catch (e) {
      print('Erro ao buscar RAC do usuário no Firestore: $e');
      throw e;
    }
  }

  static Future<String> getUserGenderFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('gender')) {
          return userData['gender'];
        } else {
          print('Gênero do usuário não encontrado');
          return '';
        }
      } else {
        print('Documento do usuário não encontrado');
        return '';
      }
    } catch (e) {
      print('Erro ao buscar gênero do usuário no Firestore: $e');
      throw e;
    }
  }

  //get user birth
  static Future<DateTime> getUserBirthDateFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('birthDate')) {
          return userData['birthDate'].toDate();
        } else {
          print('Data de nascimento do usuário não encontrada');
          return DateTime.now();
        }
      } else {
        print('Documento do usuário não encontrado');
        return DateTime.now();
      }
    } catch (e) {
      print('Erro ao buscar data de nascimento do usuário no Firestore: $e');
      throw e;
    }
  }

  //retornar idade do usuario a partir do aniversario
  static Future<int> getUserAgeFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('birthDate')) {
          DateTime birthDate = userData['birthDate'].toDate();
          DateTime now = DateTime.now();
          int age = now.year - birthDate.year;
          if (now.month < birthDate.month ||
              (now.month == birthDate.month && now.day < birthDate.day)) {
            age--;
          }
          return age;
        } else {
          print('Data de nascimento do usuário não encontrada');
          return 0;
        }
      } else {
        print('Documento do usuário não encontrado');
        return 0;
      }
    } catch (e) {
      print('Erro ao buscar data de nascimento do usuário no Firestore: $e');
      throw e;
    }
  }

  // pegar peso a partir do usuario logado
  static Future<double> getUserWeightFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('weight')) {
          return userData['weight'];
        } else {
          print('Peso do usuário não encontrado');
          return 0;
        }
      } else {
        print('Documento do usuário não encontrado');
        return 0;
      }
    } catch (e) {
      print('Erro ao buscar peso do usuário no Firestore: $e');
      throw e;
    }
  }

  // pegar altura a partir do usuario logado
  static Future<double> getUserHeightFromFirestore(
      String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('height')) {
          return userData['height'];
        } else {
          print('Altura do usuário não encontrada');
          return 0;
        }
      } else {
        print('Documento do usuário não encontrado');
        return 0;
      }
    } catch (e) {
      print('Erro ao buscar altura do usuário no Firestore: $e');
      throw e;
    }
  }

  // pegar user diabetes type
  static Future<String> getUserDiabetesTypeFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('diabetesType')) {
          return userData['diabetesType'];
        } else {
          print('Tipo de diabetes do usuário não encontrado');
          return '';
        }
      } else {
        print('Documento do usuário não encontrado');
        return '';
      }
    } catch (e) {
      print('Erro ao buscar tipo de diabetes do usuário no Firestore: $e');
      throw e;
    }
  }

  //sair da conta a partir do usuario logado
  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final router = GoRouter.of(context);
      router.go('/');
      print('Usuário deslogado com sucesso');
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  //deletar conta a partir do usuario logado
  static Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        final router = GoRouter.of(context);
        router.go('/');
        print('Usuário deletado com sucesso');
      } else {
        print('Usuário não encontrado');
      }
    } catch (e) {
      print('Erro ao deletar usuário: $e');
    }
  }

}
