import 'package:firebase_auth/firebase_auth.dart';

class MyAuthService {
  static FirebaseAuth ref = FirebaseAuth.instance;

  static Future<User> registerUser(String email, String password) async {
    UserCredential result = await ref.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user;
  }

  static Future<User> signWithEmail(String email, String password) async {
    UserCredential result =
        await ref.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user;
    return user;
  }

  static signOut() {
    ref.signOut();
  }
}
