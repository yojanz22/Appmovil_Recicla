import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mapa.dart'; // Asegúrate de que la ruta sea correcta
import 'splash_screen.dart'; // Importa la pantalla de inicio
import 'crear_point.dart'; // Importa la página "crear_point.dart"
import 'productos.dart'; // Importa la página de productos
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
      title: 'Material App',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(),
                  ),
                );
              },
              child: Text('Ir al mapa'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CrearPointPage(), // Navega a la página "crear_point.dart"
                  ),
                );
              },
              child: Text('Ir a Crear Punto'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductosPage(), // Navega a la página de productos
                  ),
                );
              },
              child: Text('Ir a Productos'),
            ),
          ],
        ),
      ),
    );
  }
}
