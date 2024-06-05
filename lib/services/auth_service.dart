import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  cadastroUsuario({
    required String nome,
    required String email,
    required String senha,
  }) {
    _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  loginUsuario({
    required String email,
    required String senha,
  }) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
  }
}
