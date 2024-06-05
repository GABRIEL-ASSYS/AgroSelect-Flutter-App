import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> cadastroUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } catch (e) {
      throw Exception('Erro ao cadastrar usuário: $e');
    }
  }

  Future<void> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }
}
