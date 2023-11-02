import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'crear_anuncio.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Manejo de la falta de servicio de ubicación
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Manejo de la denegación de permisos de ubicación
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        // Aquí se encuentra el botón "Crear Anuncio"
        child: ElevatedButton(
          onPressed: () {
            if (_currentPosition != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CrearAnuncioPage(
                    location: _currentPosition,
                  ),
                ),
              );
            } else {
              // Manejo de la falta de ubicación actual
            }
          },
          child: Text('Crear Anuncio'),
        ),
      ),
    );
  }
}
