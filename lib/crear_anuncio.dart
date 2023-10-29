import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CrearAnuncioPage extends StatefulWidget {
  final Position location; // Recibe la ubicación desde MapScreen

  CrearAnuncioPage({required this.location});

  @override
  _CrearAnuncioPageState createState() => _CrearAnuncioPageState();
}

class _CrearAnuncioPageState extends State<CrearAnuncioPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController direccionController =
      TextEditingController(); // Agregado
  String direccionDeReferencia = ''; // Agregado
  bool isLoading = false; // Agregado

  void _crearAnuncio(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final cantidad = int.tryParse(cantidadController.text) ?? 0;
    final ubicacion =
        GeoPoint(widget.location.latitude, widget.location.longitude);
    final direccion =
        await _getAddressFromLocation(widget.location); // Obtener dirección

    if (nombre.isNotEmpty &&
        descripcion.isNotEmpty &&
        cantidad > 0 &&
        direccion.isNotEmpty) {
      FirebaseFirestore.instance.collection('producto').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'cantidad': cantidad,
        'ubicacion': ubicacion,
        'direccion': direccion, // Guardar dirección
        'direccionReferencia':
            direccionDeReferencia, // Guardar dirección de referencia
      }).then((value) {
        nombreController.clear();
        descripcionController.clear();
        cantidadController.clear();
        direccionController.clear(); // Limpiar el campo de dirección
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
                          Color.fromRGBO(
                              0, 128, 0, 0.5), // Color verde transparente
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
