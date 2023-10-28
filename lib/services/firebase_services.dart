import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getProducto() async {
  List<Map<String, dynamic>> productoList = [];

  CollectionReference collectionReferenceProducto = db.collection('producto');
  QuerySnapshot queryProducto = await collectionReferenceProducto.get();

  queryProducto.docs.forEach((documento) {
    productoList.add(documento.data() as Map<String, dynamic>);
  });

  return productoList;
}
