import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'producto.dart'; // Import the DetalleProductoPage

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getProducto() async {
  List<Map<String, dynamic>> productoList = [];

  CollectionReference collectionReferenceProducto = db.collection('producto');
  QuerySnapshot queryProducto = await collectionReferenceProducto.get();

  queryProducto.docs.forEach((documento) {
    Map<String, dynamic> productoData =
        documento.data() as Map<String, dynamic>;

    // Add handling for missing fields here if needed

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
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = screenWidth ~/ 200; // Ajusta el ancho de cada cuadro

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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns, // 2 elementos por fila
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8), // Margen superior para la imagen
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleProductoPage(producto: producto),
                                ),
                              );
                            },
                            child: Image.network(
                              producto['imagenURL'],
                              width: double.infinity,
                              height: 200, // Tamaño fijo para la imagen
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            producto['nombreProducto'] ??
                                'Nombre no disponible',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
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
