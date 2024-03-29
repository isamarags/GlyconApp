import 'package:flutter/material.dart';
import 'package:glycon_app/services/auth_service.dart'; // Importe o arquivo auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart'
    as FirebaseFunctions;

Future<void> registerUser(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
) async {
  String name = nameController.text;
  String email = emailController.text;
  String password = passwordController.text;
  String confirmPassword = confirmPasswordController.text;

  // Verificar se os campos estão preenchidos
  if (name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty) {
    // Verificar se as senhas coincidem
    if (password == confirmPassword) {
      User? newUser = await AuthService.registerUser(
        name: name,
        email: email,
        password: password,
      );

      if (newUser != null) {
        await FirebaseFunctions.FirebaseFunctions.saveUserNameToFirestore(
            newUser.uid, name);

        await FirebaseFunctions.FirebaseFunctions.saveGlucoseToFirestore(
          selectedDate: DateTime.now(),
          glucoseLevel: '0', // Coloque o valor da glicose aqui
          beforeMealSelected: false, // Substitua pelo valor correto
          afterMealSelected: false, // Substitua pelo valor correto
          userId: newUser.uid, // Passe o ID do usuário
        );

        await FirebaseFunctions.FirebaseFunctions.saveInsulinDataToFirestore(
          selectedDate: DateTime.now(),
          insulinValue: 'Insulina não adicionado.', // Coloque o valor da insulina aqui
          beforeMealSelected: false, // Substitua pelo valor correto
          afterMealSelected: false, // Substitua pelo valor correto
          insulinType: 'Tipo de insulina não adicionado.', // Passe o ID do usuário
          userId: newUser.uid, // Passe o ID do usuário
        );

        await FirebaseFunctions.FirebaseFunctions.savePillDataToFirestore(
          selectedDate: DateTime.now(),
          namePill: 'Medicamento não adicionado.', // Coloque o nome do remédio aqui
          quantityPill: 0, // Coloque a dose do remédio aqui
          userId: newUser.uid, // Passe o ID do usuário
        );

        await FirebaseFunctions.FirebaseFunctions.saveFoodDataToFirestore(
          selectedDate: DateTime.now(),
          nameFood: 'Alimento não adicionado', // Coloque o valor da glicose aqui
          quantityFood: 0, // Substitua pelo valor correto
          userId: newUser.uid, // Substitua pelo valor correto
          typeFood: '', // Passe o ID do usuário
        );

        context.go('/about');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Erro no cadastro',
                style: TextStyle(color: Color(0xFF4B0D07)),
              ),
              content: Text(
                'Não foi possível realizar o cadastro. Verifique seus caracteres.',
                style: TextStyle(color: Color(0xFF4B0D07)),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Color(0xFF4B0D07)),
                  ),
                ),
              ],
              backgroundColor: Color(0xFFD8A9A9),
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Erro',
              style: TextStyle(color: Color(0xFF4B0D07)),
            ),
            content: Text(
              'As senhas não coincidem.',
              style: TextStyle(color: Color(0xFF4B0D07)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF4B0D07)),
                ),
              ),
            ],
            backgroundColor: Color(0xFFD8A9A9),
          );
        },
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Erro',
            style: TextStyle(color: Color(0xFF4B0D07)),
          ),
          content: Text(
            'Por favor, preencha todos os campos.',
            style: TextStyle(color: Color(0xFF4B0D07)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF4B0D07)),
              ),
            ),
          ],
          backgroundColor: Color(0xFFD8A9A9),
        );
      },
    );
  }
}
