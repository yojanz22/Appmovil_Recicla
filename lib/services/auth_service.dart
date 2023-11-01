import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para registrar un usuario con correo y contraseña
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error al registrar: $e');
      return null;
    }
  }

  // Función para iniciar sesión con correo y contraseña
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Función para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Función para verificar si el usuario está autenticado
  Future<bool> checkAuthentication() async {
    final User? user = _auth.currentUser;
    return user != null;
  }
}
