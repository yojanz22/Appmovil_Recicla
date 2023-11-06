import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recicla/chat.dart';
import 'dart:io';

import 'package:recicla/mapa2.dart';
import 'package:recicla/chat.dart'; // Importa la página de chat

class CrearAnuncioPage extends StatefulWidget {
  final Position location;

  CrearAnuncioPage({required this.location});

  @override
  _CrearAnuncioPageState createState() => _CrearAnuncioPageState();
}

class _CrearAnuncioPageState extends State<CrearAnuncioPage> {
  final TextEditingController nombreProductoController =
      TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  String tipoDeMaterial = 'Plásticos';
  String valorUnidad = '';
  XFile? selectedImage;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void _crearAnuncio(BuildContext context) async {
    final nombreProducto = nombreProductoController.text;
    final descripcion = descripcionController.text;
    final ubicacion =
        GeoPoint(widget.location.latitude, widget.location.longitude);

    // Obtiene el usuario actual de Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;

    if (user != null &&
        nombreProducto.isNotEmpty &&
        descripcion.isNotEmpty &&
        isNumeric(valorUnidad)) {
      final anuncioRef =
          await FirebaseFirestore.instance.collection('producto').add({
        'nombreProducto': nombreProducto,
        'descripcion': descripcion,
        'valorUnidad': valorUnidad,
        'ubicacion': ubicacion,
        'tipoDeMaterial': tipoDeMaterial,
        'imagenURL': selectedImage?.path,
        'nombreUsuario':
            user.displayName, // Utiliza el nombre del usuario actual
        'userId': user.uid, // Agrega el ID de usuario
      });

      final anuncioId = anuncioRef.id; // Obtén el ID del anuncio creado

      FirebaseFirestore.instance.collection('producto').doc(anuncioId).update({
        'anuncioId': anuncioId, // Agrega el ID del anuncio a sí mismo
      });

      FirebaseFirestore.instance
          .collection('producto')
          .doc(anuncioId)
          .collection('conversations')
          .add({
        'users': [user.uid], // Añade el usuario actual a la conversación
        'anuncioId': anuncioId, // Agrega el ID del anuncio a la conversación
      });

      nombreProductoController.clear();
      descripcionController.clear();
      valorUnidad = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Anuncio creado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos correctamente'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
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
            children: [
              Text(
                'Tipo de Material',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: tipoDeMaterial,
                onChanged: (String? newValue) {
                  setState(() {
                    tipoDeMaterial = newValue!;
                  });
                },
                items: <String>[
                  'Plásticos',
                  'Papeles y Cartón',
                  'Vidrio',
                  'Lata',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Nombre del producto que quieres Reciclar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nombreProductoController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el nombre del producto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Peso',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ingrese el peso total',
                ),
                onChanged: (value) {
                  valorUnidad = value;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Descripción',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  hintText: 'Ingrese una descripción',
                ),
              ),
              if (selectedImage != null) Image.file(File(selectedImage!.path)),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _tomarFoto();
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Tomar Foto'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(0, 128, 0, 0.5),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _crearAnuncio(context);
                      },
                      child: Text('Crear Anuncio'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(0, 128, 0, 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
