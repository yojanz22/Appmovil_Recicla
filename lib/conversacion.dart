import 'package:flutter/material.dart';

class ConversacionPage extends StatefulWidget {
  final String nombreUsuario;

  ConversacionPage({required this.nombreUsuario});

  @override
  _ConversacionPageState createState() => _ConversacionPageState();
}

class _ConversacionPageState extends State<ConversacionPage> {
  List<String> mensajes = [];
  final TextEditingController mensajeController = TextEditingController();

  void _enviarMensaje() {
    final nuevoMensaje = mensajeController.text;
    if (nuevoMensaje.isNotEmpty) {
      setState(() {
        mensajes.add(nuevoMensaje);
        mensajeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat con ${widget.nombreUsuario}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                final mensaje = mensajes[index];
                return ListTile(
                  title: Text(mensaje),
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
                    controller: mensajeController,
                    decoration: InputDecoration(
                      hintText: "Escribe un mensaje",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
