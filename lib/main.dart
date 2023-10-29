import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mapa.dart'; // Asegúrate de que la ruta sea correcta
import 'splash_screen.dart'; // Importa la pantalla de inicio
import 'productos.dart'; // Importa la página de productos
import 'crear_anuncio.dart'; // Importa la página de crear anuncio
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(home: SplashScreen())); // Muestra la pantalla de inicio
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      home: MyHomePage(title: 'Página de Inicio'),
      theme: ThemeData(
        primaryColor: Colors.blue, // Color de la barra de navegación
        scaffoldBackgroundColor: Colors.white, // Color de fondo de la pantalla
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Color del botón
                onPrimary: Colors.white, // Color del texto del botón
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(),
                  ),
                );
              },
              icon: Icon(Icons.map), // Icono a la izquierda del texto
              label: Text('Ir al Mapa'), // Texto del botón
            ),
            SizedBox(height: 16), // Espacio entre los botones
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Color del botón
                onPrimary: Colors.white, // Color del texto del botón
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductosPage(),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart), // Icono a la izquierda del texto
              label: Text('Ir a Productos'), // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}
