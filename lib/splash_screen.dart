import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

    // Después de cierto tiempo, navega a la página principal
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      );
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
                  // Al tocar la pantalla, navega a la página principal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(title: 'Flutter Demo Home Page'),
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
