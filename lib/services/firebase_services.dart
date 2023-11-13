import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> subirImagen(File imageFile, String nombreImagen) async {
    try {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('tu_carpeta_en_storage/$nombreImagen')
          .putFile(imageFile);
      final String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error al subir la imagen a Firebase Storage: $e');
      return null;
    }
  }

  Future<void> crearAnuncioConImagen(Map<String, dynamic> anuncioData,
      File imageFile, String nombreImagen) async {
    try {
      final String? imageUrl = await subirImagen(imageFile, nombreImagen);

      if (imageUrl != null) {
        anuncioData['imagenURL'] = imageUrl;
        await _firestore.collection('producto').add(anuncioData);
      } else {
        print('No se pudo obtener la URL de la imagen.');
      }
    } catch (e) {
      print('Error al crear el anuncio con imagen en Firestore: $e');
    }
  }

  Future<void> addRegistro(Map<String, dynamic> registroData) async {
    try {
      await _firestore.collection('registro').add(registroData);
    } catch (e) {
      print('Error al agregar registro a Firestore: $e');
    }
  }

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
