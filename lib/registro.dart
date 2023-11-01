import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recicla/services/firebase_services.dart';

FirebaseService _firebaseService =
    FirebaseService(); // Instancia de FirebaseService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    // Después de cierto tiempo, navega a la página de registro
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(),
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
                  // Al tocar la pantalla, navega a la página de registro
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    // Supongamos que tienes un mapa con los datos del registro
    Map<String, dynamic> registroData = {
      'nombre': _nameController.text,
      'correo': _emailController.text,
      'otroCampo': 'Valor', // Otros campos de registro
    };

    // Llama a la función para agregar el registro a Firestore
    _firebaseService.addRegistro(registroData);

    // Redirige a la página de menú
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MenuPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botones para navegar a otras partes de tu aplicación
          ],
        ),
      ),
    );
  }
}
