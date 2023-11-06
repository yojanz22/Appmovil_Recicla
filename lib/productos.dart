import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recicla/crear_anuncio.dart';
import 'dart:io';

import 'package:recicla/producto.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getProducto() async {
  List<Map<String, dynamic>> productoList = [];

  CollectionReference collectionReferenceProducto = db.collection('producto');
  QuerySnapshot queryProducto = await collectionReferenceProducto.get();

  queryProducto.docs.forEach((documento) {
    Map<String, dynamic> productoData =
        documento.data() as Map<String, dynamic>;

    if (productoData.containsKey('direccion')) {
      productoData['direccion'] = productoData['direccion'];
    } else {
      productoData['direccion'] = 'Dirección no disponible';
    }

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
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // Ancho máximo de cada elemento
                  mainAxisSpacing: 16, // Espaciado vertical
                  crossAxisSpacing: 16, // Espaciado horizontal
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Image.file(
                              File(producto['imagenURL']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            producto['nombre'] ?? 'Nombre no disponible',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalleProductoPage(producto: producto),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                'Ver Detalles',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
