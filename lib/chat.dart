import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String nombreUsuario;
  final String userId; // Asegúrate de que tengas el userId y otherUserId
  final String otherUserId;

  ChatPage(
      {required this.nombreUsuario,
      required this.userId,
      required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    if (nombreUsuario.isNotEmpty) {
      // Puedes acceder a Firestore con la ruta adecuada utilizando nombreUsuario aquí.
      // Ejemplo: FirebaseFirestore.instance.collection('chat/$userId-$otherUserId/messages')
      return Scaffold(
        appBar: AppBar(
          title: Text(
              'Chat con $nombreUsuario'), // Aquí mostramos el nombre del usuario
        ),
        body: Column(
          children: [
            // Lógica y UI del chat
          ],
        ),
      );
    } else {
      // Maneja el caso en el que nombreUsuario esté vacío.
      return Scaffold(
        appBar: AppBar(
          title: Text('Error de Chat'),
        ),
        body: Center(
          child: Text('Nombre de usuario no válido'),
        ),
      );
    }
  }
}
