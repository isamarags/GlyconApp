// services/saveDataFirestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  static List<Map<String, dynamic>> glucoseData = [];
  static List<Map<String, dynamic>> insulinData = [];
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // save glucose
  static Future<void> saveGlucoseToFirestore({
    required DateTime selectedDate,
    required String glucoseLevel,
    // required bool beforeMealSelected,
    // required bool afterMealSelected,
    required String mealTime,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('glicose')
          .add({
        'selectedDate': selectedDate,
        'glucoseLevel': glucoseLevel,
        // 'beforeMealSelected': beforeMealSelected,
        // 'afterMealSelected': afterMealSelected,
        'mealTime': mealTime,
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
    required String insulinType,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('insulina')
          .add({
        'selectedDate': selectedDate,
        'insulinValue': insulinValue,
        'beforeMealSelected': beforeMealSelected,
        'afterMealSelected': afterMealSelected,
        'insulinType': insulinType,
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
    required String userId,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('medicamentos')
          .add({
        'selectedDate': selectedDate,
        'namePill': namePill,
        'quantityPill': quantityPill,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print('Erro ao salvar dados de insulina no Firestore: $e');
    }
  }
  //save collection pill

  static Future<void> saveFoodDataToFirestore({
    required DateTime selectedDate,
    required String nameFood,
    required double quantityFood,
    required String userId,
    required String typeFood,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('alimentacao')
          .add({
        'selectedDate': selectedDate,
        'nameFood': nameFood,
        'quantityFood': quantityFood,
        'typeFood': typeFood,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print('Erro ao salvar dados de insulina no Firestore: $e');
    }
  }

  // obter ultimo dado glucose
  static Future<Map<String, dynamic>> getLatestGlucoseDataFromFirestore(
      String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('glicose')
          .orderBy('selectedDate', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> glucoseData =
            docSnapshot.data() as Map<String, dynamic>;

        // print('glucoseData: $glucoseData');
        return glucoseData;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting latest glucose data: $e');
      return {};
    }
  }

  //obter todos dados glucose do dia
  static Future<List<Map<String, dynamic>>> getGlucoseDataFromFirestore(
      String userId, DateTime selectedDate) async {
    // Obter a data selecionada
    DateTime today =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // Obter a data do dia seguinte
    DateTime tomorrow =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

    // Obter a referência da coleção
    CollectionReference glucoseCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('glicose');

    // Converter os documentos em uma lista de mapas
    QuerySnapshot querySnapshot = await glucoseCollection
        .where('selectedDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('selectedDate', isLessThan: Timestamp.fromDate(tomorrow))
        .get();
    List<Map<String, dynamic>> glucoseData = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      glucoseData.add(data);
    });

    return glucoseData;
  }

// obter insulina
  static Future<Map<String, dynamic>> getLatestInsulinDataFromFirestore(
    String userId,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('insulina')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return {};
      }
      Map<String, dynamic> insulinData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      return insulinData;
    } catch (e) {
      print('Erro ao obter os dados de insulina do Firestore: $e');
      return {};
    }
  }

  // save user data
  static Future<void> saveUserNameToFirestore(
      String userId, String name) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullName': name,
      });
    } catch (e) {
      print('Erro ao salvar o nome do usuário no Firestore: $e');
    }
  }

  // static Future<void> saveUserWeightToFirestore(
  //     String userId, double weight) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(userId).set({
  //       'weight': weight,
  //     });
  //   } catch (e) {
  //     print('Erro ao salvar o peso do usuário no Firestore: $e');
  //   }
  // }

  // static Future<void> saveUserHeightToFirestore(
  //   String userId,
  //   double height,
  // ) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(userId).set({
  //       'height': height,
  //     });
  //   } catch (e) {
  //     print('Erro ao salvar a altura do usuário no Firestore: $e');
  //   }
  // }

  // get user name
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

  //get pill data

  static Future<DocumentSnapshot> getLastPillDataFromFirestore(
      String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Busque o último documento adicionado à subcoleção 'medicamentos' do usuário
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('medicamentos')
        .orderBy('selectedDate',
            descending:
                true) // Ordene os documentos pela data em ordem decrescente
        .limit(1) // Limite a consulta ao último documento
        .get();

    // Retorne o último documento, ou null se a consulta não retornou nenhum documento
    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.first;
      return firestore.doc(queryDocumentSnapshot.reference.path).get();
    } else {
      throw Exception('Nenhum documento encontrado');
    }
  }

  static Future<DocumentSnapshot> getLastInsulinDataFromFirestore(
      String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Busque o último documento adicionado à subcoleção 'insulina' do usuário
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('insulina')
        .orderBy('selectedDate', descending: true)
        .limit(1)
        .get();

    // Retorne o último documento, ou null se a consulta não retornou nenhum documento
    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.first;
      return firestore.doc(queryDocumentSnapshot.reference.path).get();
    } else {
      throw Exception('Nenhum dado de insulina encontrado');
    }
  }

  static Future<DocumentSnapshot> getLastFoodDataFromFirestore(
      String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Busque o último documento adicionado à subcoleção 'medicamentos' do usuário
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('alimentacao')
        .orderBy('selectedDate',
            descending:
                true) // Ordene os documentos pela data em ordem decrescente
        .limit(1) // Limite a consulta ao último documento
        .get();

    // Retorne o último documento, ou null se a consulta não retornou nenhum documento
    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.first;
      return firestore.doc(queryDocumentSnapshot.reference.path).get();
    }

    throw Exception('Nenhum documento encontrado');
  }

  //retornar os valores de insulina
  static Future<List<String>> fetchInsulinOptions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('insulinOptions').get();

      List<String> insulinOptions =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();

      return insulinOptions;
    } catch (e) {
      throw Exception('Erro ao buscar as opções de insulina: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getGlucoseDataWithinRange(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      // Obter a referência da coleção de dados de glicose do usuário
      CollectionReference glucoseCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('glicose');

      // Consultar os documentos dentro do intervalo de datas fornecido
      QuerySnapshot querySnapshot = await glucoseCollection
          .where('selectedDate', isGreaterThanOrEqualTo: startDate)
          .where('selectedDate', isLessThanOrEqualTo: endDate)
          .get();

      // Converter os documentos em uma lista de mapas
      List<Map<String, dynamic>> glucoseData = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        glucoseData.add(data);
      });

      return glucoseData;
    } catch (e) {
      print('Erro ao obter dados de glicose no intervalo de datas: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getGlucoseDataForDate(
      String userId, DateTime selectedDate) async {
    try {
      // Normalizar selectedDate para a meia-noite do mesmo dia
      selectedDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

      // Obter a referência da coleção de dados de glicose do usuário
      CollectionReference glucoseCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('glicose');

      // Consultar os documentos para a data selecionada
      QuerySnapshot querySnapshot = await glucoseCollection
          .where('selectedDate', isEqualTo: selectedDate)
          .get();

      // Converter os documentos em uma lista de mapas
      List<Map<String, dynamic>> glucoseData = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        glucoseData.add(data);
      });

      return glucoseData;
    } catch (e) {
      print('Erro ao obter dados de glicose para a data: $e');
      return [];
    }
  }

  // dados de glicose dos ultimos 30 dias
  static Future<List<Map<String, dynamic>>> getGlucoseDataForLast30Days(
      String userId) async {
    try {
      // Obter a data de hoje
      DateTime today = DateTime.now();

      // Obter a data de 30 dias atrás
      DateTime thirtyDaysAgo = today.subtract(Duration(days: 30));

      // Obter a referência da coleção de dados de glicose do usuário
      CollectionReference glucoseCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('glicose');

      // Consultar os documentos dentro do intervalo de datas fornecido
      QuerySnapshot querySnapshot = await glucoseCollection
          .where('selectedDate', isGreaterThanOrEqualTo: thirtyDaysAgo)
          .where('selectedDate', isLessThanOrEqualTo: today)
          .get();

      // Converter os documentos em uma lista de mapas
      List<Map<String, dynamic>> glucoseData = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        glucoseData.add(data);
      });

      return glucoseData;
    } catch (e) {
      print('Erro ao obter dados de glicose dos últimos 30 dias: $e');
      return [];
    }
  }

}
