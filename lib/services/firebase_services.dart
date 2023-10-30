import 'package:cloud_firestore/cloud_firestore.dart';

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
