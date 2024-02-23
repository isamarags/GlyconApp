import 'package:firebase_auth/firebase_auth.dart';

class SendPasswordReset {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Envio do e-mail de redefinição de senha com sucesso
      // Você pode adicionar aqui alguma lógica para feedback ao usuário, como um snackbar ou mensagem de sucesso
    } catch (e) {
      print('Erro ao enviar e-mail de redefinição de senha: $e');
    }
  }
}
