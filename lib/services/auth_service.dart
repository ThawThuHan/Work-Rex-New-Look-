import 'package:firebase_auth/firebase_auth.dart';

class MyAuthService {
  static FirebaseAuth ref = FirebaseAuth.instance;

  static Future<User> registerUser(String email, String password) async {
    try {
      UserCredential result = await ref.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.toString());
      return null;
    }
  }

  static Future<User> signWithEmail(String email, String password) async {
    try {
      UserCredential result = await ref.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    }
  }

  static signOut() {
    ref.signOut();
  }
}
