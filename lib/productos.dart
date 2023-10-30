import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io'; // Importa el paquete 'dart:io' para utilizar File

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getProducto() async {
  List<Map<String, dynamic>> productoList = [];

  CollectionReference collectionReferenceProducto = db.collection('producto');
  QuerySnapshot queryProducto = await collectionReferenceProducto.get();

  queryProducto.docs.forEach((documento) {
    // Obtén los datos del documento
    Map<String, dynamic> productoData =
        documento.data() as Map<String, dynamic>;

    // Agrega la dirección real a los datos del producto si está disponible
    if (productoData.containsKey('direccion')) {
      productoData['direccion'] = productoData['direccion'];
    } else {
      productoData['direccion'] = 'Dirección no disponible';
    }

    // Aquí asumimos que el campo 'imagenURL' contiene la ruta de la imagen en la caché
    // Puedes ajustar el nombre del campo según lo que hayas usado en Firestore
    if (productoData.containsKey('imagenURL')) {
      productoData['imagenURL'] = productoData['imagenURL'];
    } else {
      productoData['imagenURL'] = 'Ruta de imagen no disponible';
    }

    productoList.add(productoData);
  });

  return productoList;
}

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
                          if (producto['imagenURL'] != null &&
                              producto['imagenURL'] !=
                                  'Ruta de imagen no disponible')
                            Image.file(File(producto['imagenURL']),
                                width: 100, height: 100),
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
