import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'mapa2.dart'; // Asegúrate de importar la página del mapa.

class CrearAnuncioPage extends StatefulWidget {
  final Position location;

  CrearAnuncioPage({required this.location});

  @override
  _CrearAnuncioPageState createState() => _CrearAnuncioPageState();
}

class _CrearAnuncioPageState extends State<CrearAnuncioPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  String direccionDeReferencia = '';
  String tipoDeMaterial = 'Plásticos';
  bool isLoading = false;
  String tipoDeUnidad = 'KG';
  String valorUnidad = '';
  XFile? selectedImage; // Campo para almacenar la imagen seleccionada

  void _crearAnuncio(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final ubicacion =
        GeoPoint(widget.location.latitude, widget.location.longitude);
    final direccion = await _getAddressFromLocation(widget.location);

    if (nombre.isNotEmpty &&
        descripcion.isNotEmpty &&
        direccion.isNotEmpty &&
        valorUnidad.isNotEmpty) {
      FirebaseFirestore.instance.collection('producto').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'unidad': tipoDeUnidad,
        'valorUnidad': valorUnidad,
        'ubicacion': ubicacion,
        'direccion': direccion,
        'direccionReferencia': direccionDeReferencia,
        'tipoDeMaterial': tipoDeMaterial,
        'imagenURL': selectedImage?.path, // Agrega la URL de la imagen
      }).then((value) {
        nombreController.clear();
        descripcionController.clear();
        direccionController.clear();
        valorUnidad = '';
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Anuncio creado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el anuncio: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Por favor, complete todos los campos y la dirección correctamente'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _getAddressFromLocation(Position location) async {
    final addresses =
        await placemarkFromCoordinates(location.latitude, location.longitude);

    if (addresses.isNotEmpty) {
      final address = addresses.first;
      return '${address.thoroughfare} ${address.subThoroughfare}, ${address.locality}, ${address.administrativeArea}';
    } else {
      return '';
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tipo de Material',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildMaterialOption('Plásticos'),
                          _buildMaterialOption('Papeles y Cartón'),
                          _buildMaterialOption('Vidrio'),
                          _buildMaterialOption('Lata'),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nombre del Producto',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: descripcionController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese una descripción',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Dirección',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: direccionController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese la dirección',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Mapa2Page(location: widget.location),
                          ),
                        );
                      },
                      child: Text('Ver en el Mapa'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _crearAnuncio(context);
                      },
                      child: Text(
                        'Crear Anuncio',
                        style: TextStyle(color: Colors.black),
                      ),
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
                      Image.file(File(selectedImage!.path),
                          height: 100, width: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMaterialOption(String material) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tipoDeMaterial = material;
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: tipoDeMaterial == material ? Colors.blue : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            material,
            style: TextStyle(
              fontSize: 16,
              fontWeight: tipoDeMaterial == material
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
