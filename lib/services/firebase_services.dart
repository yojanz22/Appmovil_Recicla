import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Otras funciones de Firebase

  // Función para agregar un registro a la colección "registro"
  Future<void> addRegistro(Map<String, dynamic> registroData) async {
    try {
      await _firestore.collection('registro').add(registroData);
    } catch (e) {
      print('Error al agregar registro a Firestore: $e');
    }
  }

  // Función para obtener una lista de registros de la colección "registro"
  Future<List<Map<String, dynamic>>?> getRegistros() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('registro').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error al obtener registros desde Firestore: $e');
      return null;
    }
  }

  // Función para obtener una lista de productos desde la colección "producto"
  Future<List<Map<String, dynamic>>?> getProductos() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('producto').get();
      List<Map<String, dynamic>> productoList = [];

      querySnapshot.docs.forEach((documento) {
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
    } catch (e) {
      print('Error al obtener productos desde Firestore: $e');
      return null;
    }
  }
}
