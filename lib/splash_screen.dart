import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart'; // Importa la página de inicio de sesión
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
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _controller.repeat(reverse: true);

    // Realizar la verificación de autenticación
    _authService.checkAuthentication().then((isAuthenticated) {
      Future.delayed(Duration(seconds: 3), () {
        // Espera 3 segundos y luego navega a la página de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(), // Cambiado a LoginPage
          ),
        );
      });
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
              angle: _controller.value * 6.3,
              child: GestureDetector(
                onTap: () {
                  // Al tocar la pantalla, navega a la página de inicio de sesión
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: ClipOval(
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
