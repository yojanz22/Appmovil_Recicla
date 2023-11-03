import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'crear_anuncio.dart';
import 'mapa2.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position _currentPosition;
  bool _locationObtained = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si los servicios de ubicación no están habilitados, muestra una alerta al usuario.
      _showLocationServiceAlert();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si el usuario deniega los permisos de ubicación, muestra una alerta.
        _showLocationPermissionAlert();
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _locationObtained = true;
    });
  }

  void _showLocationServiceAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Servicio de ubicación deshabilitado'),
          content: Text(
              'Por favor, active el servicio de ubicación en la configuración de su dispositivo.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permisos de ubicación denegados'),
          content: Text(
              'Por favor, habilite los permisos de ubicación en la configuración de su dispositivo.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_locationObtained) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Mapa2Page(location: _currentPosition),
                    ),
                  );
                }
              },
              child: Text('Ir a Mapa 2'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_locationObtained) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CrearAnuncioPage(location: _currentPosition),
                    ),
                  );
                }
              },
              child: Text('Crear Anuncio'),
            ),
          ],
        ),
      ),
    );
  }
}
