import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  static Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final logger = Logger();

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      await user!.updateDisplayName(name);
      await user.reload();
      final updatedUser = auth.currentUser;

      if (updatedUser != null) {
        logger.i('User registered: ${updatedUser.uid}, Name: ${updatedUser.displayName}');
      } else {
        logger.i('Failed to update user profile.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.e('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.e('The account already exists for that email.');
      } else {
        logger.e(e);
      }

      return null;
    }

    return user;
  }
}
