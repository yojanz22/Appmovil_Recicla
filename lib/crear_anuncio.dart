import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  String tipoDeUnidad = 'KG'; // Valor predeterminado de la unidad

  String valorUnidad = ''; // Almacena el valor de la unidad (peso o cantidad)

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
        'valorUnidad': valorUnidad, // Nuevo campo para el valor de la unidad
        'ubicacion': ubicacion,
        'direccion': direccion,
        'direccionReferencia': direccionDeReferencia,
        'tipoDeMaterial': tipoDeMaterial,
      }).then((value) {
        nombreController.clear();
        descripcionController.clear();
        direccionController.clear();
        valorUnidad = ''; // Restablece el valor de la unidad
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
                    DropdownButton<String>(
                      value: tipoDeMaterial,
                      onChanged: (String? newValue) {
                        setState(() {
                          tipoDeMaterial = newValue!;
                        });
                      },
                      items: <String>[
                        'Plásticos',
                        'Papeles y cartón',
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
                    Row(
                      children: [
                        Text('Tipo de Unidad: '),
                        DropdownButton<String>(
                          value: tipoDeUnidad,
                          onChanged: (String? newValue) {
                            setState(() {
                              tipoDeUnidad = newValue!;
                              if (tipoDeUnidad == 'Cantidad') {
                                valorUnidad =
                                    ''; // Restablece el valor de la unidad
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
                        decoration:
                            InputDecoration(labelText: 'Ingresa el peso (KG)'),
                        onChanged: (value) {
                          valorUnidad = value;
                        },
                      )
                    else if (tipoDeUnidad == 'Cantidad')
                      TextField(
                        decoration:
                            InputDecoration(labelText: 'Ingresa la cantidad'),
                        onChanged: (value) {
                          valorUnidad = value;
                        },
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
                      controller: direccionController,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
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
                          Color.fromRGBO(0, 128, 0, 0.5),
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
