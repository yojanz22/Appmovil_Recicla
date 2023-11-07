import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversacionPage extends StatefulWidget {
  final String nombreUsuario;
  final String userId;
  final String otherUserId;

  ConversacionPage({
    required this.nombreUsuario,
    required this.userId,
    required this.otherUserId,
  });

  @override
  _ConversacionPageState createState() => _ConversacionPageState();
}

class _ConversacionPageState extends State<ConversacionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUserID = widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.nombreUsuario}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection(
                      'chats/${_generateConversationId(currentUserID, widget.otherUserId)}/messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final senderID = message['senderId'];
                  final messageText = message['text'];

                  // Determina si el mensaje es del usuario actual
                  final isCurrentUser = senderID == currentUserID;

                  messageWidgets.add(Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: isCurrentUser ? Colors.blue : Colors.green,
                      child: Text(
                        messageText,
                        style: TextStyle(
                          color: isCurrentUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ));
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Write a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      _enviarMensaje(messageController.text);
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

  void _enviarMensaje(String text) async {
    try {
      final conversationId =
          _generateConversationId(widget.userId, widget.otherUserId);

      await _firestore.collection('chats/$conversationId/messages').add({
        'text': text,
        'senderId': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  String _generateConversationId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) < 0) {
      return '$userId1-$userId2';
    } else {
      return '$userId2-$userId1';
    }
  }
}
