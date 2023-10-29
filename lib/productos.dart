import 'package:flutter/material.dart';
import 'package:recicla/services/firebase_services.dart';

class ProductosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: FutureBuilder(
        future: getProducto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            final productos = snapshot.data as List<Map<String, dynamic>>;

            if (productos.isNotEmpty) {
              return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    elevation: 4, // Sombra del card
                    margin: EdgeInsets.all(8), // Margen alrededor del card
                    child: ListTile(
                      title: Text(producto['nombre'] ?? 'Nombre no disponible'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto['descripcion'] ??
                                'Descripción no disponible',
                          ),
                          Text(
                            'Cantidad: ${producto['cantidad'] ?? 'Cantidad no disponible'}',
                          ),
                          Text(
                            'Dirección: ${producto['direccion'] ?? 'Dirección no disponible'}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No se encontraron productos.'),
              );
            }
          }
          return Center(
            child: Text('No se encontraron productos.'),
          );
        },
      ),
    );
  }
}
