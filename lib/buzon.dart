import 'package:flutter/material.dart';
import 'package:recicla/conversacion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuzonPage extends StatefulWidget {
  @override
  _BuzonPageState createState() => _BuzonPageState();
}

class _BuzonPageState extends State<BuzonPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buzón de Mensajes"),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final messages =
              snapshot.data?.docs ?? []; // Acceso condicional a docs
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final senderId = message['senderId'];
              final text = message['text'];

              return ListTile(
                title: Text(
                    'Mensaje de: $senderId'), // Aquí muestras el nombre o ID del remitente
                subtitle: Text(text), // Aquí muestras el texto del mensaje
                onTap: () {
                  // Navega a la página de conversación con este usuario
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ConversacionPage(
                        nombreUsuario:
                            senderId, // Nombre del usuario con el que estás chateando
                        userId: 'tu_id_de_usuario_aqui', // Tu ID de usuario
                        otherUserId: senderId, // ID del otro usuario
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
