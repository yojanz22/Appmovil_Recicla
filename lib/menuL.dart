import 'package:flutter/material.dart';
import 'login.dart'; // Importa la página de inicio de sesión
import 'registro.dart'; // Importa la página de registro

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  double buttonContainerHeight =
      0.0; // Altura inicial del contenedor de botones
  double backgroundOpacity = 0.0; // Opacidad inicial del fondo

  @override
  void initState() {
    super.initState();
    // Inicia la animación para mostrar los botones desde abajo y el fondo desde el centro
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        buttonContainerHeight =
            MediaQuery.of(context).size.height; // Altura de toda la pantalla
        backgroundOpacity = 1.0; // Opacidad completa
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/fondo.jpeg'), // Ruta de tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedOpacity(
            duration: Duration(seconds: 2), // Duración de la animación
            opacity: backgroundOpacity, // Opacidad animada del fondo
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.transparent), // Fondo transparente
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.green,
                              width: 2.0)), // Contorno verde
                        ),
                        onPressed: () {
                          // Navega a la página de inicio de sesión
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(color: Colors.black), // Texto negro
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.transparent), // Fondo transparente
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.green,
                              width: 2.0)), // Contorno verde
                        ),
                        onPressed: () {
                          // Navega a la página de registro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          'Registrarse',
                          style: TextStyle(color: Colors.black), // Texto negro
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
