import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  static Future<User?> signInUser({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final logger = Logger();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        logger.i('User signed in: ${user.uid}, Email: ${user.email}');
      } else {
        logger.i('Failed to sign in user.');
      }

      return user; // Retorna o usuário logado
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.e('Wrong password provided for that user.');
      } else {
        logger.e(e);
      }

      return null; // Retorna null em caso de erro no login
    }
  }
}
