import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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
  bool isLoading = false;

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

    final user = FirebaseAuth.instance.currentUser;

    if (user != null &&
        nombreProducto.isNotEmpty &&
        descripcion.isNotEmpty &&
        isNumeric(valorUnidad) &&
        selectedImage != null) {
      setState(() {
        isLoading = true;
      });

      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$nombreProducto');
      UploadTask uploadTask =
          storageReference.putFile(File(selectedImage!.path));

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      final anuncioData = {
        'nombreProducto': nombreProducto,
        'descripcion': descripcion,
        'valorUnidad': valorUnidad,
        'ubicacion': ubicacion,
        'tipoDeMaterial': tipoDeMaterial,
        'imagenURL': imageUrl,
        'nombreUsuario': user.displayName,
        'userId': user.uid,
      };

      final anuncioRef = await FirebaseFirestore.instance
          .collection('producto')
          .add(anuncioData);

      final anuncioId = anuncioRef.id;
      FirebaseFirestore.instance.collection('producto').doc(anuncioId).update({
        'anuncioId': anuncioId,
      });

      FirebaseFirestore.instance
          .collection('producto')
          .doc(anuncioId)
          .collection('conversations')
          .add({
        'users': [user.uid],
        'anuncioId': anuncioId,
      });

      nombreProductoController.clear();
      descripcionController.clear();
      valorUnidad = '';
      selectedImage = null;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Anuncio creado con éxito',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, complete todos los campos correctamente',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imagen subida correctamente',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
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
      body: Stack(
        children: [
          Center(
            child: Padding(
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
                  ElevatedButton(
                    onPressed: () {
                      _tomarFoto();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 128, 0, 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt),
                        Text('Tomar Foto'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _crearAnuncio(context);
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 128, 0, 0.5),
                      ),
                    ),
                    child: Text('Crear Anuncio'),
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Creando anuncio...',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
