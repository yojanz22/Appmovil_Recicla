import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String nombreUsuario;
  final String userId;
  final String otherUserId;

  ChatPage({
    required this.nombreUsuario,
    required this.userId,
    required this.otherUserId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  late User currentUser;
  List<String> messages = []; // Lista para almacenar los mensajes

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser!;
    _loadMessages(); // Carga los mensajes existentes al inicio
  }

  void _loadMessages() {
    _firestore
        .collection('chats')
        .where('senderId', isEqualTo: currentUser.uid)
        .where('receiverId', isEqualTo: widget.otherUserId)
        .orderBy('timestamp', descending: true)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        messages.clear(); // Limpia la lista actual
        querySnapshot.docs.forEach((doc) {
          final messageText = doc['text'];
          messages.add(messageText); // Agrega los mensajes a la lista
        });
        setState(() {}); // Actualiza la UI para mostrar los mensajes
      }
    }).catchError((error) {
      print('Error loading messages: $error');
    });
  }

  void _sendMessage(String text) async {
    try {
      await _firestore.collection('chats').add({
        'text': text,
        'senderId': currentUser.uid,
        'receiverId': widget.otherUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
      _loadMessages(); // Carga los mensajes actualizados
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.nombreUsuario}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              reverse: true,
              children:
                  messages.map((messageText) => Text(messageText)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      _sendMessage(messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
