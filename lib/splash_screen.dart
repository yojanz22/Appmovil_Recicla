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

class _SplashScreenState extends State<SplashScreen> {
  double _positionY = -150.0; // Inicialmente, por encima de la pantalla
  double _velocity = 0.0;
  double _gravity = 0.2;
  int _bounceCount = 0;

  @override
  void initState() {
    super.initState();
    _startFallingAnimation();
  }

  void _startFallingAnimation() {
    Future.delayed(Duration(milliseconds: 16), () {
      setState(() {
        _velocity += _gravity;
        _positionY += _velocity;

        if (_positionY >= 250.0) {
          _positionY = 250.0; // Limita la caída al centro de la pantalla
          _velocity =
              -_velocity; // Invertir la velocidad para simular un rebote
          _bounceCount++;

          if (_bounceCount >= 3) {
            // Después de 3 rebotes, navega a la página principal
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: 'Flutter Demo Home Page'),
                ),
              );
            });
          }
        }
      });

      if (_bounceCount < 3) {
        _startFallingAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 16),
          transform: Matrix4.translationValues(0, _positionY, 0),
          child: ClipOval(
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/logo.jpeg',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
