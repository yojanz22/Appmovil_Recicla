import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuzonPage extends StatefulWidget {
  @override
  _BuzonPageState createState() => _BuzonPageState();
}

class _BuzonPageState extends State<BuzonPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> _messages;
  late List<String> _nombresRemitentes;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _firestore.collection('chats').get();
    _messages =
        messages.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    _loadNombresRemitentes();
  }

  Future<void> _loadNombresRemitentes() async {
    _nombresRemitentes = [];
    for (var message in _messages) {
      final senderId = message['senderId'];
      final nombreRemitente = await _getNombreRemitente(senderId);
      _nombresRemitentes.add(nombreRemitente);
    }
    setState(
        () {}); // Actualiza la interfaz de usuario después de cargar los nombres.
  }

  Future<String> _getNombreRemitente(String senderId) async {
    try {
      final senderDoc =
          await _firestore.collection('registro').doc(senderId).get();
      return senderDoc['nombreUsuario'] ?? senderId;
    } catch (e) {
      print('Error al obtener nombre del remitente: $e');
      return 'Remitente Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buzón de Mensajes'),
      ),
      body: _nombresRemitentes == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final senderId = message['senderId'];
                final text = message['text'];
                final nombreRemitente = _nombresRemitentes[index];

                return ListTile(
                  title: Text('Mensaje de: $nombreRemitente'),
                  subtitle: Text(text),
                  onTap: () {
                    _abrirChat(
                      context,
                      nombreRemitente: nombreRemitente,
                      userId: 'tu_id_de_usuario_aqui',
                      otherUserId: senderId,
                    );
                  },
                );
              },
            ),
    );
  }

  void _abrirChat(BuildContext context,
      {required String nombreRemitente,
      required String userId,
      required String otherUserId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          nombreUsuario: nombreRemitente,
          userId: userId,
          otherUserId: otherUserId,
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String nombreUsuario;
  final String userId;
  final String otherUserId;

  ChatPage({
    required this.nombreUsuario,
    required this.userId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    // Implementa tu pantalla de chat aquí.
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $nombreUsuario'),
      ),
      body: Center(
        child: Text('Implementa la pantalla de chat aquí'),
      ),
    );
  }
}
