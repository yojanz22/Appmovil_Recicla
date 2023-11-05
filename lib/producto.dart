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
              Image.network(
                producto['imagenURL'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text(
              producto['nombre'] ?? 'Nombre no disponible',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              producto['descripcion'] ?? 'Descripción no disponible',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Tipo de Unidad: ${producto['unidad'] ?? 'Unidad no disponible'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Valor de Unidad: ${producto['valorUnidad'] ?? 'Valor no disponible'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Dirección: ${producto['direccion'] ?? 'Dirección no disponible'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
