import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String
      nombreUsuario; // Cambia el nombre de la variable a "nombreUsuario"

  ChatPage({required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Chat con $nombreUsuario'), // Muestra el nombre del usuario en la barra
      ),
      body: Column(
        children: [
          // Aquí puedes agregar la lógica y la interfaz de usuario del chat
          // Para mostrar los mensajes y permitir enviar mensajes.
        ],
      ),
    );
  }
}
