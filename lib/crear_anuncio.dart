import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearAnuncioPage extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();

  void _crearAnuncio(BuildContext context) {
    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final cantidad = int.tryParse(cantidadController.text) ?? 0;

    if (nombre.isNotEmpty && descripcion.isNotEmpty && cantidad > 0) {
      FirebaseFirestore.instance.collection('producto').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'cantidad': cantidad,
      }).then((value) {
        nombreController.clear();
        descripcionController.clear();
        cantidadController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anuncio creado con éxito')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el anuncio: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Por favor, complete todos los campos correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Anuncio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ingrese nombre de lo que quiere reciclar:'),
            TextField(
              controller: nombreController,
            ),
            SizedBox(height: 16),
            Text('Ingrese una descripción:'),
            TextField(
              controller: descripcionController,
            ),
            SizedBox(height: 16),
            Text('Ingrese una cantidad:'),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _crearAnuncio(context);
              },
              child: Text('Crear Anuncio'),
            ),
          ],
        ),
      ),
    );
  }
}
