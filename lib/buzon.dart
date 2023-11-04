import 'package:flutter/material.dart';
import 'package:recicla/conversacion.dart';

class BuzonPage extends StatefulWidget {
  @override
  _BuzonPageState createState() => _BuzonPageState();
}

class _BuzonPageState extends State<BuzonPage> {
  List<String> usuarios = [
    "Usuario 1",
    "Usuario 2",
    "Usuario 3",
    // Agrega más usuarios según tus datos de Firebase
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buzón de Mensajes"),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario),
            onTap: () {
              // Navega a la página de conversación con este usuario
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ConversacionPage(nombreUsuario: usuario),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
