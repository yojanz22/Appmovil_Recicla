import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CrearAnuncioPage extends StatefulWidget {
  final Position location;

  CrearAnuncioPage({required this.location});

  @override
  _CrearAnuncioPageState createState() => _CrearAnuncioPageState();
}

class _CrearAnuncioPageState extends State<CrearAnuncioPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  String tipoDeMaterial = 'Plásticos';
  String tipoDeUnidad = 'KG';
  String valorUnidad = '';
  XFile? selectedImage;

  void _crearAnuncio(BuildContext context) async {
    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final ubicacion =
        GeoPoint(widget.location.latitude, widget.location.longitude);

    if (nombre.isNotEmpty && descripcion.isNotEmpty && valorUnidad.isNotEmpty) {
      FirebaseFirestore.instance.collection('producto').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'unidad': tipoDeUnidad,
        'valorUnidad': valorUnidad,
        'ubicacion': ubicacion,
        'tipoDeMaterial': tipoDeMaterial,
        'imagenURL': selectedImage?.path,
      }).then((value) {
        nombreController.clear();
        descripcionController.clear();
        valorUnidad = '';
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

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
                'Nombre del Producto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el nombre del producto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Tipo de Unidad',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    value: tipoDeUnidad,
                    onChanged: (String? newValue) {
                      setState(() {
                        tipoDeUnidad = newValue!;
                        if (tipoDeUnidad == 'Cantidad') {
                          valorUnidad = '';
                        }
                      });
                    },
                    items: <String>[
                      'KG',
                      'Cantidad',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (tipoDeUnidad == 'KG')
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ingresa el peso (KG)',
                  ),
                  onChanged: (value) {
                    valorUnidad = value;
                  },
                )
              else if (tipoDeUnidad == 'Cantidad')
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ingresa la cantidad',
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
              SizedBox(height: 16),
              ElevatedButton(
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _seleccionarImagen();
                },
                child: Text('Seleccionar Imagen'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(0, 128, 0, 0.5),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (selectedImage != null)
                Image.file(File(selectedImage!.path), height: 100, width: 100),
            ],
          ),
        ),
      ),
    );
  }
}
