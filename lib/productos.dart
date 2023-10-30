import 'package:flutter/material.dart';
import 'package:recicla/services/firebase_services.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  late Future<List<Map<String, dynamic>>> productosFuture;

  @override
  void initState() {
    super.initState();
    productosFuture = getProducto();
  }

  Future<void> _actualizarProductos() async {
    setState(() {
      productosFuture = getProducto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _actualizarProductos,
          ),
        ],
      ),
      body: FutureBuilder(
        future: productosFuture,
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
                    elevation: 4,
                    margin: EdgeInsets.all(8),
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
                            'Tipo de Unidad: ${producto['unidad'] ?? 'Unidad no disponible'}',
                          ),
                          Text(
                            'Valor de Unidad: ${producto['valorUnidad'] ?? 'Valor no disponible'}',
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
