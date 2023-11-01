import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menuL.dart'; // Importa la página de menú
import 'services/auth_service.dart'; // Importa la clase de servicio de autenticación

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(home: SplashScreen())); // Muestra la pantalla de inicio
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
          seconds: 5), // Ajusta la duración para una rotación más lenta
      vsync: this,
    );
    _controller.repeat(
        reverse: true); // Hacer que la animación rote continuamente

    // Realizar la verificación de autenticación
    _authService.checkAuthentication().then((isAuthenticated) {
      if (isAuthenticated) {
        // Si el usuario está autenticado, navega a la página de menú
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 6.3, // Rotar de 0 a 360 grados
              child: GestureDetector(
                onTap: () {
                  // Al tocar la pantalla, navega a la página de menú
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPage(),
                    ),
                  );
                },
                child: ClipOval(
                  // Agregamos ClipOval para hacer el logotipo redondo
                  child: Image.asset(
                    'assets/logo.jpeg',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
