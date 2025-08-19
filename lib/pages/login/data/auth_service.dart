
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);
  /*
  думал над демо методом где простой вход будет с логин-паролем demo-demo,
  учитывая что мы пилим online-first аппку решил не мучаться с эмулятором
  FireBase
  */
  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
