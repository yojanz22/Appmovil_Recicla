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

    // Agrega la dirección a los datos del producto si está disponible
    productoData['direccion'] =
        'Dirección de prueba'; // Reemplaza con el campo real de dirección

    productoList.add(productoData);
  });

  return productoList;
}
