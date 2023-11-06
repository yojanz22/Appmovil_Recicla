import 'package:flutter/material.dart';

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
            if (producto['imagenURL'] != null &&
                producto['imagenURL'] != 'Ruta de imagen no disponible')
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
              producto['nombre'] ?? 'Nombre no disponible',
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
                'Tipo de Unidad:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                producto['unidad'] ?? 'Unidad no disponible',
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
            ListTile(
              title: Text(
                'Dirección:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                producto['direccion'] ?? 'Dirección no disponible',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
