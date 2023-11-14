import 'package:flutter/material.dart';
import 'package:recicla/chat.dart';
import 'chat.dart'; // Asegúrate de importar la página de chat

class DetalleProductoPage extends StatelessWidget {
  final Map<String, dynamic> producto;

  DetalleProductoPage({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                producto['imagenURL'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              producto['nombreProducto'] ?? 'Nombre no disponible',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            ListTile(
              title: Text(
                'Descripción:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                producto['descripcion'] ?? 'Descripción no disponible',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Valor de Unidad:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                producto['valorUnidad'] ?? 'Valor no disponible',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      nombreUsuario: producto['nombreUsuario'],
                      userId:
                          'ID_DEL_USUARIO_ACTUAL', // Coloca el ID del usuario actual
                      otherUserId: producto['userId'],
                    ),
                  ),
                );
              },
              child: Text('Hablar con la persona'),
            ),
          ],
        ),
      ),
    );
  }
}
