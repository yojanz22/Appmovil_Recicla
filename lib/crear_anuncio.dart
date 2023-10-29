import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class CrearAnuncioPage extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final Position location; // Recibe la ubicación desde MapScreen

  CrearAnuncioPage({required this.location});

  void _crearAnuncio(BuildContext context) {
    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final cantidad = int.tryParse(cantidadController.text) ?? 0;

    if (nombre.isNotEmpty && descripcion.isNotEmpty && cantidad > 0) {
      FirebaseFirestore.instance.collection('producto').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'cantidad': cantidad,
        'ubicacion': GeoPoint(location.latitude, location.longitude),
      }).then((value) {
        nombreController.clear();
        descripcionController.clear();
        cantidadController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Anuncio creado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el anuncio: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos correctamente'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Anuncio'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _crearAnuncio(context);
                },
                child: Text('Crear Anuncio',
                    style: TextStyle(color: Colors.green)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(0, 128, 0, 0.5), // Color verde transparente
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
